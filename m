Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaG3Vmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:42:47 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:59342 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbaG3Vmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:42:45 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: mcree@orcon.net.nz, linux-alpha@vger.kernel.org
Subject: [PATCH 0/2] alpha updates
Date: Wed, 30 Jul 2014 11:42:30 -1000
Message-Id: <1406756552-23864-1-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch should fix the clone bug that Michael Cree reported.
The second patch adds the three new syscalls since the last update.

The tree can be found at

  git://github.com/rth7680/linux.git axp-next


r~


Richard Henderson (2):
  alpha: Remove "strange" OSF/1 fork semantics
  alpha: Add sched_set/getattr and renameat2 syscalls

 arch/alpha/include/asm/unistd.h      | 2 +-
 arch/alpha/include/uapi/asm/unistd.h | 3 +++
 arch/alpha/kernel/process.c          | 2 --
 arch/alpha/kernel/systbls.S          | 3 +++
 4 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.9.3

