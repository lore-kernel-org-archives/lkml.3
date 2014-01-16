Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010AbaAPPYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:24:18 -0500
Received: from sam.nabble.com ([216.139.236.26]:54612 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaAPPYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:24:15 -0500
Date: Thu, 16 Jan 2014 07:24:15 -0800 (PST)
From: rahulk <rahulk1208@gmail.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1389885855032-788341.post@n7.nabble.com>
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
Subject: Re: [ 000/102] 3.10.6-stable review
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am working on Xilinx zc702 board with Kernel 3.10.0. Now i want to upgrade
the kernel. While doing these upgradation activity 3.10.4 and 3.10.5 kernel
with xilinx patch sucessfully run on the board. But 3.10.6 kernel with
xilinx patch is not working on the board. Kernel get stuck after console
message "Starting kernel ..." in 3.10.6 kernel. As per my understanding
after these meassage kernel is not getting the entry point of kernel to
Uncompress it. The console messages are given below

zynq-uboot> run sdboot
Copying Linux from SD to RAM...
Device: SDHCI
Manufacturer ID: 87
OEM: 494f
Name: SD
Tran Speed: 50000000
Rd Block Len: 512
SD version 2.0
High Capacity: No
Capacity: 977 MiB
Bus Width: 4-bit
reading uImage

6229968 bytes read
reading devicetree.dtb

10125 bytes read
reading uramdisk.image.gz

4075970 bytes read
## Booting kernel from Legacy Image at 03000000 ...
   Image Name:   Linux-3.10.6-vestas
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    6229904 Bytes = 5.9 MiB
   Load Address: 00008000
   Entry Point:  00008000
   Verifying Checksum ... OK
## Loading init Ramdisk from Legacy Image at 02000000 ...
   Image Name:
   Image Type:   ARM Linux RAMDisk Image (gzip compressed)
   Data Size:    4075906 Bytes = 3.9 MiB
   Load Address: 00000000
   Entry Point:  00000000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 02a00000
   Booting using the fdt blob at 0x02a00000
   Loading Kernel Image ... OK
OK
   Loading Ramdisk to 1fc1c000, end 1ffff182 ... OK
   Loading Device Tree to 1fc16000, end 1fc1b78c ... OK

Starting kernel ...











--
View this message in context: http://linux-kernel.2935.n7.nabble.com/000-102-3-10-6-stable-review-tp699811p788341.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
