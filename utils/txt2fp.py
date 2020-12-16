import hashlib
import numpy as np
import pandas as pd


def read_file(file_path: str, sep: str = ',') -> np.array:
    """This function opens a file and reads its content as a numpy
    array with the data.

    Params
    ------------------------------------------------------------------
        file_path: str.
            Path to the file.
        sep: str.
            Data separator.

    Returns
    ------------------------------------------------------------------
        2D Numpy array with (x, y) format.
    """
    # Read CSV as DataFrame
    pdFunction: pd.DataFrame = pd.read_csv(file_path, sep=sep, header=1,
                                           names=['t', 'y'])

    return pdFunction['t'].values, pdFunction['y'].values

def float2q15_16(file_name: str, time: np.array, samples: np.array,
                 f: float = 40e3) -> None:
    """
    """
    q15_16_samples: list = []
    q15_16_time: list = []
    time_step: float = 1/f
    current_t: float = 0.0
    i: int = 0

    for t, sample in zip(time, samples):
        if current_t <= t:
            # Convert float sample to Q15.16
            ones: int = int(23*sample/5)
            zeros: int = 23 - ones
            value: int = int(f'{"0"*(9 + zeros)}{"1"*ones}', base=2)
            hex_value: str = hex(value)[2:]
            q15_16_samples.append(f'{i} :{"0"*(8 - len(hex_value))}{hex_value};')
            q15_16_time.append(t)

            # Next time
            current_t += time_step
            i += 1

    # Create and open files
    samples_file: _io.TextIOWrapper = open('data_' + file_name + '.mif', 'w')
    time_file: _io.TextIOWrapper = open('time_' + file_name + '.txt', 'w')

    # Write header
    samples_file.write(f'DEPTH = {len(q15_16_samples)}; \n')
    samples_file.write(f'WIDTH = {32}; \n')
    samples_file.write(f'ADDRESS_RADIX = DEC;\n')
    samples_file.write(f'DATA_RADIX = HEX; \n')
    samples_file.write(f'CONTENT \nBEGIN \n')

    # Save time and samples
    samples_file.write('\n'.join([s for s in q15_16_samples]))
    samples_file.write('\nEND;\n')
    time_file.write('\n'.join([str(t) for t in q15_16_time]))

    # Close files
    samples_file.close()
    time_file.close()


if __name__ == '__main__':
    file_path = 'ChannelD.csv'
    time, samples = read_file(file_path)
    float2q15_16('sample', time, samples, f=40e3)

