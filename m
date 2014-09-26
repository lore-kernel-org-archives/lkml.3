Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaIZBCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:02:04 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:21242 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaIZBCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:02:01 -0400
Message-ID: <5424BB01.8040305@huawei.com>
Date: Fri, 26 Sep 2014 09:01:53 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>
CC: <lwn@lwn.net>
Subject: Linux 3.4.104
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm announcing the release of the 3.4.104 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

- ----------------------------------------------------------------

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Andi Kleen (1):
      slab/mempolicy: always use local policy from interrupt context

Anton Blanchard (1):
      ibmveth: Fix endian issues with rx_no_buffer statistic

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

Fengguang Wu (1):
      unicore32: select generic atomic64_t support

Florian Fainelli (1):
      MIPS: perf: Fix build error caused by unused counters_per_cpu_to_total()

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Guan Xuetao (2):
      UniCore32-bugfix: Remove definitions in asm/bug.h to solve difference between native and cross compiler
      UniCore32-bugfix: fix mismatch return value of __xchg_bad_pointer

Hans de Goede (1):
      xhci: Treat not finding the event_seg on COMP_STOP the same as COMP_STOP_INVAL

Huang Rui (1):
      usb: xhci: amd chipset also needs short TX quirk

James Forshaw (1):
      USB: whiteheat: Added bounds checking for bulk command response

Jan Kara (2):
      isofs: Fix unbounded recursion when processing relocated directories
      ext2: Fix fs corruption in ext2_get_xip_mem()

Ja
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlQkuwEACgkQWyV2+h1UztNI2QCgjdz894R+7HCEozS+rP/LZIWQ
oOMAniLGoXrPt4qKVfoH4/uvVMS+KgDW
=y055
-----END PGP SIGNATURE-----
