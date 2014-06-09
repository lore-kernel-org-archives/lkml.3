Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688AbaFIPv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:51:59 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58875 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932682AbaFIPv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:51:57 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@rustcorp.com.au,
        "GitAuthor: Pranith Kumar" <bobby.prani@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/6] remove dead link, kerneltrap.org no longer works
Date: Mon,  9 Jun 2014 11:51:24 -0400
Message-Id: <1402329088-4802-2-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
References: <1402329088-4802-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kerneltrap.org no longer works, remove the dead reference

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/SubmittingDrivers | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/Documentation/SubmittingDrivers b/Documentation/SubmittingDrivers
index 36d16bb..31d3726 100644
--- a/Documentation/SubmittingDrivers
+++ b/Documentation/SubmittingDrivers
@@ -146,10 +146,6 @@ LWN.net:
 	Porting drivers from prior kernels to 2.6:
 		http://lwn.net/Articles/driver-porting/
 
-KernelTrap:
-	Occasional Linux kernel articles and developer interviews
-	http://kerneltrap.org/
-
 KernelNewbies:
 	Documentation and assistance for new kernel programmers
 	http://kernelnewbies.org/
-- 
1.9.1

