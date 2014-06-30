Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaF3UeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:34:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaF3UeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:34:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.26 stable review
Date: Mon, 30 Jun 2014 13:34:00 -0700
Message-Id: <1404160444-9157-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.26 stable kernel.

This version contains 4 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.26 will be open for the next one day.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/mach-omap2/cclock3xxx_data.c |   3 +-
 include/linux/lzo.h                   |  15 +-
 lib/decompress_unlzo.c                |   2 +-
 lib/lzo/Makefile                      |   2 +-
 lib/lzo/lzo1x_compress.c              | 335 ++++++++++++++++++++--------------
 lib/lzo/lzo1x_decompress.c            | 255 --------------------------
 lib/lzo/lzo1x_decompress_safe.c       | 257 ++++++++++++++++++++++++++
 lib/lzo/lzodefs.h                     |  38 ++--
 8 files changed, 489 insertions(+), 418 deletions(-)

Greg Kroah-Hartman (1):
      lzo: properly check for overruns

Kamal Mostafa (1):
      [3.8-stable-only] Revert "ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms"

Markus F.X.J. Oberhumer (2):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
      lib/lzo: Update LZO compression to current upstream version
