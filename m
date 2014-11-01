Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaKAKwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 06:52:30 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56879 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbaKAKw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 06:52:29 -0400
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <willy@meta-x.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] staging: panel: Remove outdated TODO task
Date: Sat,  1 Nov 2014 11:52:11 +0100
Message-Id: <1414839131-21428-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove Lindent task from TODO file as it's obsolete.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
v4: Keep checkpatch.pl on the list as there are still some strict issues.

 drivers/staging/panel/TODO | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/panel/TODO b/drivers/staging/panel/TODO
index a4be749..2db3f99 100644
--- a/drivers/staging/panel/TODO
+++ b/drivers/staging/panel/TODO
@@ -1,6 +1,5 @@
 TODO:
 	- checkpatch.pl cleanups
-	- Lindent
 	- review major/minor usages
 	- review userspace api
 	- see if all of this could be easier done in userspace instead.
-- 
2.1.3

