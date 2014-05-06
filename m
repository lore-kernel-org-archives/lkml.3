Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbaEFUm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:42:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaEFUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:42:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.1 stable review (new patches)
Date: Tue,  6 May 2014 13:42:17 -0700
Message-Id: <1399408940-22784-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New patches have been added during this review cycle for the Linux 3.13.11.1
stable kernel.

The 3 new patches are summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 drivers/block/floppy.c | 11 +++++++----
 drivers/tty/n_tty.c    |  4 ++++
 2 files changed, 11 insertions(+), 4 deletions(-)

Matthew Daley (2):
      floppy: ignore kernel-only members in FDRAWCMD ioctl input
      floppy: don't write kernel-only members to FDRAWCMD ioctl output

Peter Hurley (1):
      n_tty: Fix n_tty_write crash when echoing in raw mode
