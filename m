Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbaFIPwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:52:33 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:34938 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795AbaFIPwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:52:24 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@rustcorp.com.au, Harry Wei <harryxiyou@gmail.com>,
        linux-kernel@zh-kernel.org (moderated list:CHINESE DOCUMENTA...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 6/6] remove dead link, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:51:28 -0400
Message-Id: <1402329088-4802-6-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
References: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, remove dead reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/zh_CN/SubmittingDrivers | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/zh_CN/SubmittingDrivers b/Documentation/zh_CN/SubmittingDrivers
index 5889f8d..d313f5d 100644
--- a/Documentation/zh_CN/SubmittingDrivers
+++ b/Documentation/zh_CN/SubmittingDrivers
@@ -150,10 +150,6 @@ LWN.net:
 	将旧版内核的驱动程序移植到 2.6 版：
 		http://lwn.net/Articles/driver-porting/
 
-KernelTrap：
-	Linux 内核的最新动态以及开发者访谈
-	http://kerneltrap.org/
-
 内核新手(KernelNewbies):
 	为新的内核开发者提供文档和帮助
 	http://kernelnewbies.org/
-- 
1.9.1

