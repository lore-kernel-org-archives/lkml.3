Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaCJBWJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 21:22:09 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47284 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaCJBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 21:22:07 -0400
MIME-Version: 1.0
Date: Sun, 9 Mar 2014 21:22:06 -0400
Message-ID: <CAGsCrgDXxJGO4-2hwVQ-biPHWeL8VG8K=75W4JyCYa7TJtNQjA@mail.gmail.com>
Subject: LK bug with SGH-T999V (d2tmo)
From: Pierre-Yves Tremblay <pytremblay@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. LK v9.2 and higher won't work at all on d2tmo nightlies&stable
(CM11) and on d2lte nightlies (CM11) for SGH-T999V

2. The phone just can't run with this kernel anymore since version 9.2
(d2att) with cm11's d2tmo and version 9.4 (d2) with cm11's d2lte.
Phone app crashes repetitively with v9.4 of d2 with CM11's latest
nightlies of d2lte. With v9.1 of d2att and cm11's nightlies of d2tmo,
lk has always worked very well, same for previous versions of lk's
d2att combined with cm10's d2tmo nightlies. 9.2 and higher just
totally fail at boot with my phone. I don't remember exactly if it was
a phone app crash or something else, but it was a major fail at boot
just like it is now with the repetitive phone app crash caused by lk
9.4 (d2) with cm11's d2lte.

3. Repetitive phone app crash at boot

4.1 root@d2tmo:/ # cat /proc/version
Linux version 3.4.82-cyanogenmod-g5d45d15 (build03@cyanogenmod) (gcc
version 4.7 (GCC) ) #1 SMP PREEMPT Sat Mar 8 16:53:43 PST 2014

4.2 leankernel can't run on d2lte for my phone

5. v9.1 from d2att with cm11's d2tmo

8. SGH-T999V Canadian Galaxy S3 provided by Videotron running CM11.
The bug has been happening on both nightly&stable versions of CM11's
d2tmo and nightly versions of d2lte.

I'm unable to run leankernel anymore since I have upgraded from d2tmo
to d2lte nightlies on CM11. I had been trying lk 9.2 (d2att) for a
while but it always failed. I can't use version 9.1 from d2att with
d2lte nightlies, so now i'm running without leankernel and I miss it.

1|root@d2tmo:/ # cat /proc/cpuinfo
cat /proc/cpuinfo
Processor       : ARMv7 Processor rev 0 (v7l)
processor       : 0
BogoMIPS        : 13.50

processor       : 1
BogoMIPS        : 13.50

Features        : swp half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva id
ivt
CPU implementer : 0x51
CPU architecture: 7
CPU variant     : 0x1
CPU part        : 0x04d
CPU revision    : 0

Hardware        : SAMSUNG M2
Revision        : 0010
Serial          : 0000a1070000aa56
root@d2tmo:/ # cat /proc/modules
cat /proc/modules
dhd 324767 0 - Live 0x00000000
root@d2tmo:/ # cat /proc/ioports
cat /proc/ioports
00000008-00000008 : i2c_sda
00000009-00000009 : i2c_clk
0000000a-0000000a : gpio_host_wake
0000000c-0000000c : a2220_sda
0000000d-0000000d : a2220_sck
00000026-00000026 : spi_mosi
00000027-00000027 : spi_miso
00000028-00000028 : spi_cs
00000029-00000029 : spi_clk
0000004f-0000004f : gpio_ext_wake
00000054-00000058 : wcnss_gpios_5wire
0000011d-0000011d : pmic_rtc_base
root@d2tmo:/ # cat /proc/iomem
cat /proc/iomem
00500000-00500fff : msm_ssbi.0
00700000-007060ff : hdmi_msm_qfprom_addr
0080207c-0080207f : slimbus_slew_reg
03000000-0327ffff : wcnss_mmio
  03204000-032040ff : pil_riva
04100000-04100fff : kgsl_2d0_reg_memory
  04100000-04100fff : kgsl-2d0
04200000-04200fff : kgsl_2d1_reg_memory
  04200000-04200fff : kgsl-2d1
04300000-0431ffff : kgsl_3d0_reg_memory
  04300000-0431ffff : kgsl-3d0
04400000-044fffff : msm_vidc.0
04500000-045fffff : vfe32
  04500000-045fffff : msm_vfe
04600000-046fffff : msm_gemini.0
04700000-047effff : mipi_dsi
04800000-048003ff : csid
  04800000-048003ff : msm_csid
04800400-048007ff : csid
  04800400-048007ff : msm_csid
04800800-04800bff : ispif
  04800800-04800bff : msm_ispif
04800c00-04800fff : csiphy
  04800c00-04800fff : msm_csiphy
04801000-048013ff : csiphy
  04801000-048013ff : msm_csiphy
04a00000-04a00fff : hdmi_msm_hdmi_addr
04e00000-04efffff : msm_rotator.0
05100000-051effff : mdp
05300000-053fffff : vpe
  05300000-053fffff : msm_vpe
07300000-073fffff : physbase
  07300000-073fffff : physbase
07400000-074fffff : physbase
  07400000-074fffff : physbase
07500000-075fffff : physbase
  07500000-075fffff : physbase
07600000-076fffff : physbase
  07600000-076fffff : physbase
07700000-077fffff : physbase
  07700000-077fffff : physbase
07800000-078fffff : physbase
  07800000-078fffff : physbase
07900000-079fffff : physbase
  07900000-079fffff : physbase
07a00000-07afffff : physbase
  07a00000-07afffff : physbase
07b00000-07bfffff : physbase
  07b00000-07bfffff : physbase
07c00000-07cfffff : physbase
  07c00000-07cfffff : physbase
07d00000-07dfffff : physbase
  07d00000-07dfffff : physbase
07e00000-07efffff : physbase
  07e00000-07efffff : physbase
08800000-088000ff : pil_qdsp6v4.1
08900000-089000ff : pil_qdsp6v4.2
08b00000-08b00003 : pil_qdsp6v4.1
  08b00000-08b00003 : pil_qdsp6v4.2
12180000-121807ff : core_mem
12180800-12181fff : dml_mem
12182000-12183fff : bam_mem
121c0000-121c07ff : core_mem
121c0800-121c1fff : dml_mem
121c2000-121c3fff : bam_mem
12240000-12240fff : bamdma_dma
12244000-12247fff : bamdma_bam
12400000-124007ff : core_mem
12400800-12401fff : dml_mem
12402000-12403fff : bam_mem
12440000-12440003 : gsbi_base
  12440000-12440003 : spi_qsd
12460000-12460fff : spi_base
  12460000-12460fff : spi_qsd
12480000-12480003 : gsbi_qup_i2c_addr
  12480000-12480003 : qup_i2c
124a0000-124a0fff : qup_phys_addr
  124a0000-124a0fff : qup_i2c
12500000-12501000 : msm_hsusb
  12500000-12501000 : msm_otg
    12500000-12500fff : msm_hsusb_host
12800000-12803fff : pipe_mem
16000000-16000003 : gsbi_qup_i2c_addr
  16000000-16000003 : qup_i2c
16080000-16080fff : qup_phys_addr
  16080000-16080fff : qup_i2c
16200000-16200003 : gsbi_qup_i2c_addr
  16200000-16200003 : qup_i2c
16280000-16280fff : qup_phys_addr
  16280000-16280fff : qup_i2c
16300000-16300003 : gsbi_qup_i2c_addr
  16300000-16300003 : qup_i2c
16380000-16380fff : qup_phys_addr
  16380000-16380fff : qup_i2c
16400000-16400fff : gsbi_resource
16440000-16440fff : uartdm_resource
  16440000-16440fff : msm_serial_hsl
16500000-16500003 : gsbi_resource
  16500000-16500003 : msm_serial_hs
16540000-16540fff : uartdm_resource
16600000-16600fff : gsbi_qup_i2c_addr
  16600000-16600fff : qup_i2c
16680000-16680003 : qup_phys_addr
  16680000-16680003 : qup_i2c
18320000-1841ffff : msm_dmov
18500000-1850ffff : qce.0
  18500000-1850ffff : qcrypto.0
1a000000-1a000003 : gsbi_qup_i2c_addr
  1a000000-1a000003 : qup_i2c
1a080000-1a080fff : qup_phys_addr
  1a080000-1a080fff : qup_i2c
1a200000-1a200003 : gsbi_qup_i2c_addr
  1a200000-1a200003 : qup_i2c
1a280000-1a280fff : qup_phys_addr
  1a280000-1a280fff : qup_i2c
1a500000-1a5001ff : msm_rng.0
28080000-28081fff : slimbus_physical
28084000-28085fff : slimbus_bam_physical
28800000-288000ff : pil_qdsp6v4.0
2a03f720-2a04071f : tz_log.0
80200000-88cfffff : System RAM
  80208000-80c8cecb : Kernel code
  80ce0000-810c3bbb : Kernel data
8f200000-8f6fffff : System RAM
8fb00000-8fdfffff : rmtfs
90000000-9fdfffff : System RAM
a6100000-ff2fefff : System RAM
root@d2tmo:/ # lspci -vvv
lspci -vvv
sh: lspci: not found
127|root@d2tmo:/ # lspci
lspci
sh: lspci: not found
127|root@d2tmo:/ # cat /proc/scsi/scsi
cat /proc/scsi/scsi
root@d2tmo:/ #



If I can do anything to help you out to help me with this problem, just ask!

I've been using leankernel on this phone for about 1.5 years and it's
great! I would like to be able to use leankernel again. I love it.


Thank you.

P-Y
