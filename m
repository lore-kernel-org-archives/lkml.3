Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab3HNMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:25:57 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:44154 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759697Ab3HNMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:25:55 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 0/3] locks: trivial locks.c patches
Date: Wed, 14 Aug 2013 08:25:46 -0400
Message-Id: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few reasonably trivial patches for locks.c. Al, can you apply these
for 3.12?

Jeff Layton (3):
  locks: clean up comment typo
  locks: remove "inline" qualifier from fl_link manipulation functions
  locks: add __acquires and __releases annotations to locks_start and
    locks_stop

 fs/locks.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

-- 
1.8.3.1

