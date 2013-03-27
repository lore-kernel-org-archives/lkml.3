Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3C0KtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:49:11 -0400
Received: from multi.imgtec.com ([194.200.65.239]:5693 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3C0Kso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:48:44 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Jeff Dike <jdike@addtoit.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Richard Weinberger" <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/3] hostfs: tweaks from imgdafs review
Date: Wed, 27 Mar 2013 10:47:11 +0000
Message-ID: <1364381234-22960-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_10_48_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset contains some tweaks to hostfs, based on imgdafs review
comments from Al Viro which also apply to hostfs.

James Hogan (3):
  hostfs: remove "will unlock" comment
  hostfs: move HOSTFS_SUPER_MAGIC to <linux/magic.h>
  hostfs: use kmalloc instead of kzalloc

 fs/hostfs/hostfs_kern.c    | 8 ++++----
 include/uapi/linux/magic.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
1.8.1.2


