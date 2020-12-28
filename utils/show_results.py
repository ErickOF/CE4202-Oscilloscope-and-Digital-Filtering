import matplotlib.pyplot as plt
import numpy as np


def show(values, lp_values, hp_values):
    plt.subplot(4, 1, 1)
    plt.plot(values)
    plt.legend(['Original'])

    plt.subplot(4, 1, 2)
    plt.plot(lp_values)
    plt.legend(['Pasa Bajas'])

    plt.subplot(4, 1, 3)
    plt.plot(hp_values)
    plt.legend(['Pasa Altas'])

    plt.subplot(4, 1, 4)
    plt.plot(hp_values[:100])
    plt.legend(['Pasa Altas'])
    plt.show()


if __name__ == '__main__':
    output_path: str = '../digital_filter/output.txt'
    input_path: str = '../digital_filter/data_sample.txt'
    lp_values: list = []
    hp_values: list = []
    input_values: list = []

    with open(input_path, 'r') as file:
        input_values: list = [int(b, base=2) for b in file.read().split('\n')]

    with open(output_path, 'r') as file:
        data: list = file.read().split('\n')
        
        for values in data:
            if values:
                lp, hp = values.split(',')

                if (lp[0] == '1'):
                    value = -(int(''.join('0' if a == '1' else '1' for a in lp), base=2) + 1)
                    lp_values.append(value)
                else:
                    lp_values.append(int(lp, base=2))

                if (hp[0] == '1'):
                    value = -(int(''.join('0' if a == '1' else '1' for a in hp), base=2) + 1)
                    hp_values.append(value)
                else:
                    hp_values.append(int(hp, base=2))

    show(input_values, lp_values, hp_values)
