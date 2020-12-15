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
    # Convert , to dot
    pdFunction: pd.DataFrame = pdFunction.apply(lambda x: x.str.replace(',','.'))
    # Convert to float
    pdFunction: pd.DataFrame = pdFunction.astype('float')

    return pdFunction['t'].values, pdFunction['y'].values

def float2q15_16(file_name: str, time: np.array, samples: np.array):
    """
    """
    q15_16_samples: list = []

    for sample in samples:
        # Convert float sample to Q15.16
        ones: int = int(23*sample/5)
        zeros: int = 23 - ones
        q15_16_samples.append(f'{"0"*(9 + zeros)}{"1"*ones}')

    # Create and open files
    samples_file: _io.TextIOWrapper = open('data_' + file_name, 'w')
    time_file: _io.TextIOWrapper = open('time_' + file_name, 'w')

    # Save time
    samples_file.write('\n'.join([s for s in q15_16_samples]))
    time_file.write('\n'.join([str(t) for t in time]))

    # Close files
    samples_file.close()
    time_file.close()


if __name__ == '__main__':
    file_path = 'ChannelD.csv'
    time, samples = read_file(file_path, sep=';')
    float2q15_16('sample.txt', time, samples)
