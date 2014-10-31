Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbaJaVeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:34:36 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:60856 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563AbaJaVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:34:35 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: panel: Remove outdated TODO tasks
Date: Fri, 31 Oct 2014 22:27:39 +0100
Message-Id: <1414790859-7480-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Lindent and checkpatch.pl tasks from TODO file as the first one
is obsolete and the other one is already done.

v2: Fixed commit summary

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/TODO | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
index a4be749..c8040c1 100644
--- a/drivers/staging/panel/TODO
+++ b/drivers/staging/panel/TODO
@@ -1,6 +1,4 @@
 TODO:
-	- checkpatch.pl cleanups
-	- Lindent
 	- review major/minor usages
 	- review userspace api
 	- see if all of this could be easier done in userspace instead.
-- 
2.1.3

