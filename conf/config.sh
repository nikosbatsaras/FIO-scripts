#!/usr/bin/env bash

FIO='/home/nx05/nx05/kolokasis/fio-fio-3.10/fio'

FIO_PATH='/home/nx05/nx05/kolokasis/FIO-scripts'

FIO_SCRIPTS="${FIO_PATH}/scripts/pmem"

RUN_FIO="${FIO_PATH}/runfio.sh"

DEVICES=( '/mnt/pmem_fsdax0' )

THREADS=( 1 2 4 8 16 32 48 )

IODEPTH=( 1 4 16 32 64 )
