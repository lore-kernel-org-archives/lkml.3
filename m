Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331AbaGAWHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:07:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40956 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030262AbaGAWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:06:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.26
Date: Tue,  1 Jul 2014 15:06:52 -0700
Message-Id: <1404252413-30482-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.26 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.25 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Makefile                              |   2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c |   3 +-
 include/linux/lzo.h                   |  15 +-
 lib/decompress_unlzo.c                |   2 +-
 lib/lzo/Makefile                      |   2 +-
 lib/lzo/lzo1x_compress.c              | 335 ++++++++++++++++++++--------------
 lib/lzo/lzo1x_decompress.c            | 255 --------------------------
 lib/lzo/lzo1x_decompress_safe.c       | 257 ++++++++++++++++++++++++++
 lib/lzo/lzodefs.h                     |  38 ++--
 9 files changed, 490 insertions(+), 419 deletions(-)

Greg Kroah-Hartman (1):
      lzo: properly check for overruns

Kamal Mostafa (2):
      [3.8-stable-only] Revert "ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to dpll4_m5 on all OMAP3 platforms"
      Linux 3.8.13.26

Markus F.X.J. Oberhumer (2):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
      lib/lzo: Update LZO compression to current upstream version

