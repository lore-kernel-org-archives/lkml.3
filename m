Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbaKFBoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:44:19 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:55805 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFBoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:44:16 -0500
From: Richard Yao <ryao@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mateusz Guzik <mguzik@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@gentoo.org, Matthew Thode <mthode@mthode.org>,
        =?UTF-8?q?Michael=20M=C3=BCller?= <michael@fds-team.de>,
        Daniel Robbins <drobbins@funtoo.org>, Richard Yao <ryao@gentoo.org>
Subject: [PATCH v4 0/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Wed,  5 Nov 2014 20:44:02 -0500
Message-Id: <1415238243-5929-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Linus,

I am the ZFSOnLinux developer that ran into you on his way to the airport at
LinuxCon Europe last month. This is the VFS patch that you volunteered to help
me get properly reviewed. My plan was to send it the week after LinuxCon Europe
(last week) as you had asked. However, that was delayed until Monday last week.

Coincidentally, I was in Boston last week and I had the opportunity to chat
with Ted about filesystem stuff in person. He suggested me that this patch
likely got lost in your inbox. He has also volunteered to review the patch and
asked that I resend.

This patch fixes a bug that has annoyed both myself and others for some time
now. I am presently super busy preparing for next week's Open ZFS developer
summit, but I would love to see this patch merged. I will make time to respond
to any emails regarding it.

Yours truly,
Richard Yao

Richard Yao (1):
  vfs: Respect MS_RDONLY at bind mount creation

 fs/namespace.c | 20 ++++++++++++++++----
 fs/pnode.h     | 17 +++++++++--------
 2 files changed, 25 insertions(+), 12 deletions(-)

-- 
2.0.4

