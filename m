Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaCYXtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:49:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46251 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaCYXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:49:51 -0400
From: Mitchel Humpherys <mitchelh@codeaurora.org>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: [PATCH 1/2] Documentation/SubmittingPatches: update some dead URLs
Date: Tue, 25 Mar 2014 16:49:32 -0700
Message-Id: <1395791373-3694-2-git-send-email-mitchelh@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395791373-3694-1-git-send-email-mitchelh@codeaurora.org>
References: <1395791373-3694-1-git-send-email-mitchelh@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The links to "The perfect patch" and "NO!!!! No more huge patch
bombs..." have gone stale. Update them to some working locations.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
---
 Documentation/SubmittingPatches       | 4 ++--
 Documentation/ja_JP/SubmittingPatches | 4 ++--
 Documentation/zh_CN/SubmittingPatches | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31d5a..af80689517 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -725,7 +725,7 @@ SECTION 3 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -738,7 +738,7 @@ Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/linux/maintainer-05.html>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://users.sosdg.org/~qiyong/lxr/source/Documentation/CodingStyle>
diff --git a/Documentation/ja_JP/SubmittingPatches b/Documentation/ja_JP/SubmittingPatches
index 97f78dd0c0..ff6cb5729c 100644
--- a/Documentation/ja_JP/SubmittingPatches
+++ b/Documentation/ja_JP/SubmittingPatches
@@ -695,7 +695,7 @@ gcc においては、マクロと同じくらい軽いです。
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -707,7 +707,7 @@ Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/2006/01/11/>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://users.sosdg.org/~qiyong/lxr/source/Documentation/CodingStyle>
diff --git a/Documentation/zh_CN/SubmittingPatches b/Documentation/zh_CN/SubmittingPatches
index be0bd47250..788ab47303 100644
--- a/Documentation/zh_CN/SubmittingPatches
+++ b/Documentation/zh_CN/SubmittingPatches
@@ -394,7 +394,7 @@ Static inline 函数相比宏来说，是好得多的选择。Static inline 函
 ----------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -406,7 +406,7 @@ Greg Kroah-Hartman, "How to piss off a kernel subsystem maintainer".
   <http://www.kroah.com/log/2006/01/11/>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://sosdg.org/~coywolf/lxr/source/Documentation/CodingStyle>
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

