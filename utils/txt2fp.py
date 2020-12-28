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
    pdFunction: pd.DataFrame = pd.read_csv(file_path, sep=sep, header=0,
                                           names=['t', 'y'])

    return pdFunction['t'].values, pdFunction['y'].values

def float2q15_16(file_name: str, time: np.array, samples: np.array,
                 f: float = 40e3) -> None:
    """
    """
    max_value: int = 2**23
    q15_16_samples: list = []
    q15_16_time: list = []
    time_step: float = 1/f
    current_t: float = 0.0
    i: int = 0

    for t, sample in zip(time, samples):
        if current_t <= t:
            # Convert float sample to Q15.16
            bin_value: str = bin(int(np.round(sample*max_value/5)))[2:]
            zeros: int = 32 - len(bin_value)

            q15_16_samples.append(f'{"0"*zeros}{bin_value}')
            q15_16_time.append(t)

            # Next time
            current_t += time_step
            i += 1

    # Create and open files
    samples_file: _io.TextIOWrapper = open('data_' + file_name + '.txt', 'w')
    time_file: _io.TextIOWrapper = open('time_' + file_name + '.txt', 'w')

    # Save time and samples
    samples_file.write('\n'.join([s for s in q15_16_samples]))
    time_file.write('\n'.join([str(t) for t in q15_16_time]))

    # Close files
    samples_file.close()
    time_file.close()


if __name__ == '__main__':
    file_path = 'ChannelD.csv'
    time, samples = read_file(file_path)
    float2q15_16('sample', time, samples, f=40e3)

