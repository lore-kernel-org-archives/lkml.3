Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab3I1L1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 07:27:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59048 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab3I1L0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 07:26:49 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH 0/2] Lower entry barrier for arm64 development
Date: Sat, 28 Sep 2013 16:49:54 +0530
Message-Id: <1380367196-28295-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g4cae6f5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So I got this far after many hours of scratching my head. Let's make
EXT4, VIRTIO_MMIO, and VIRTIO_BLK part of the default configuration so
users have a pleasant ride when attempting to run their freshly built
AArch64 kernel. My boot wrapper has diverged from Catalin's quite
significantly [1], and it works well for me. I intend to address more
papercuts in future patches.

Thanks.

[1]: https://github.com/artagnon/boot-wrapper-aarch64

Ramkumar Ramachandra (2):
  arm64: include EXT4 in defconfig
  arm64: include VIRTIO_{MMIO,BLK} in defconfig

 arch/arm64/configs/defconfig | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.4.477.g4cae6f5

