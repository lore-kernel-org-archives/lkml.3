Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3JWGW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:22:58 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:54264 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3JWGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:22:56 -0400
X-AuditID: cbfec372-b7fe76d000003347-e7-52676b3f7d85
Date: Wed, 23 Oct 2013 07:22:51 +0100
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v3.13-rc6] media fixes
Message-id: <20131023072251.5820cdb1.m.chehab@samsung.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e9wkK59dnqQQe8CQYs569ewWVzeNYfN
	omfDVlaLR31v2R1YPE7M+M3i8XmTXABTFJdNSmpOZllqkb5dAlfGmbfvWAr+SFec2P2cuYHx
	mmgXIyeHhICJxIkvx5khbDGJC/fWs3UxcnEICSxhlPj7dj0LSEJIoIFJ4tjhHBCbRUBVYsLp
	drA4m4CRxKvGFlYQWwTI/vziCitIM7PAYkaJj8/Xs4MkhAV0Jb40TGMEsXkFrCT6VncDbeMA
	2uYksfuAFERYUOLH5HtgM5kFtCQ2b2tihbDlJTavecs8gZFvFpKyWUjKZiEpW8DIvIpRtLQ4
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjJPCKdjA+22B1iFGAg1GJh/dBS1qQEGtiWXFl7iFGCQ5m
	JRHeZl+gEG9KYmVValF+fFFpTmrxIUYmDk6pBsbDZua6Smr6x5YnVPBWpogtOnh/sx/rzttH
	68R/GNf+Cu+3mm+vb5SauWje9KlNHz6urMjKkLzyZStj7iPBxC9G0Y6rVhd832a3TW7X0YmJ
	pvIPp6zfkdl9eYKXP5vOic5jrOVMtl/l3wrdfOtck7iy/bvdjhfTODaUcS/7UHlldc0b31fb
	MuWUWIozEg21mIuKEwHiq1omGgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a series of fixes for the media subsystem, including:
	- Compilation fixes for GCC < 4.4.6;
	- one Kbuild dependency select fix (selecting videobuf on msi3101);
	- driver fixes on tda10071, e4000, msi3101, soc_camera, s5p-jpeg,
	  saa7134 and adv7511;
	- some device quirks needed to make them work properly;
	- some videobuf2 core regression fixes for some features used only on 
	  embedded drivers.

Thanks!
Mauro

The following changes since commit 4a10c2ac2f368583138b774ca41fac4207911983:

  Linux 3.12-rc2 (2013-09-23 15:41:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 9c9cff55bf4f13dc2fffb5abe466f13e4ac155f9:

  [media] saa7134: Fix crash when device is closed before streamoff (2013-10-14 06:37:00 -0300)

----------------------------------------------------------------
Andreas Matthies (1):
      [media] tda10071: change firmware download condition

Antti Palosaari (3):
      [media] e4000: fix PLL calc bug on 32-bit arch
      [media] msi3101: Kconfig select VIDEOBUF2_VMALLOC
      [media] msi3101: correct max videobuf2 alloc

Dan Carpenter (2):
      [media] sh_vou: almost forever loop in sh_vou_try_fmt_vid_out()
      [media] mx3-camera: locking cleanup in mx3_videobuf_queue()

Fengguang Wu (1):
      [media] msi3101: msi3101_ioctl_ops can be static

Gianluca Gennari (4):
      [media] adv7842: fix compilation with GCC < 4.4.6
      [media] adv7511: fix compilation with GCC < 4.4.6
      [media] ad9389b: fix compilation with GCC < 4.4.6
      [media] ths8200: fix compilation with GCC < 4.4.6

Gregor Jasny (1):
      [media] Add HCL T12Rg-H to STK webcam upside-down table

Jacek Anaszewski (1):
      [media] s5p-jpeg: Initialize vfd_decoder->vfl_dir field

Joseph Salisbury (1):
      [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor

Laurent Pinchart (1):
      [media] uvcvideo: quirk PROBE_DEF for Microsoft Lifecam NX-3000

Marek Szyprowski (1):
      [media] videobuf2-dc: Fix support for mappings without struct page in userptr mode

Simon Farnsworth (1):
      [media] saa7134: Fix crash when device is closed before streamoff

Sylwester Nawrocki (1):
      [media] vb2: Allow queuing OUTPUT buffers with zeroed 'bytesused'

Wei Yongjun (1):
      [media] adv7511: fix error return code in adv7511_probe()

 drivers/media/dvb-frontends/tda10071.c         |  9 +--
 drivers/media/i2c/ad9389b.c                    | 15 ++---
 drivers/media/i2c/adv7511.c                    | 18 +++---
 drivers/media/i2c/adv7842.c                    | 30 ++++-----
 drivers/media/i2c/ths8200.c                    | 12 ++--
 drivers/media/pci/saa7134/saa7134-video.c      |  1 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c    |  1 +
 drivers/media/platform/sh_vou.c                |  2 +-
 drivers/media/platform/soc_camera/mx3_camera.c |  5 +-
 drivers/media/tuners/e4000.c                   |  3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c       |  7 +++
 drivers/media/usb/uvc/uvc_driver.c             | 18 ++++++
 drivers/media/v4l2-core/videobuf2-core.c       |  4 +-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 87 ++++++++++++++++++++++++--
 drivers/staging/media/msi3101/Kconfig          |  1 +
 drivers/staging/media/msi3101/sdr-msi3101.c    | 10 ++-
 16 files changed, 158 insertions(+), 65 deletions(-)
