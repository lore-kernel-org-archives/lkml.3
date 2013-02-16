Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3BPIhN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:37:13 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:55787 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPIhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:37:11 -0500
From: Robert Berger <git.rber@gmail.com>
To: devel@driverdev.osuosl.org, konrad.wilk@oracle.com
Cc: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, git.rber@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: [PATCH 1/4] staging/zache checkpatch ERROR: spaces prohibited around that
Date: Sat, 16 Feb 2013 10:35:51 +0200
Message-Id: <1361003754-22512-2-git-send-email-rber.git@ReliableEmbeddedSystems.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
References: <git.rber@gmail.com>
 <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zbud.c:106: ERROR: spaces prohibited around that ':' (ctx:VxW)
zbud.c:107: ERROR: spaces prohibited around that ':' (ctx:VxW)

Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
---
 drivers/staging/zcache/zbud.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index 79ae9bd..57b72e3 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -103,8 +103,8 @@ struct zbudpage {
 		struct {
 			unsigned long space_for_flags;
 			struct {
-				unsigned zbud0_size: PAGE_SHIFT;
-				unsigned zbud1_size: PAGE_SHIFT;
+				unsigned zbud0_size:PAGE_SHIFT;
+				unsigned zbud1_size:PAGE_SHIFT;
 				unsigned unevictable:2;
 			};
 			struct list_head budlist;
-- 
1.7.9.5

