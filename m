Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaINNFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:05:46 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:56455 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaINNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:05:44 -0400
Message-ID: <1410699283.5595.1.camel@centos.angelo.com>
Subject: [PATCH] Set EXTRAVERSION to -eudyptula of Makefile
From: Amitabha Yin <angelo.yin@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Sep 2014 20:54:43 +0800
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5 (3.8.5-22.el7_0.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Set EXTRAVERSION to -eudyptula in Makefile for 
Task 03 of the Eudyptula Challenge.

Signed-off-by: Ping Yin <angelo.yin@gmail.com>
--
diff --git a/Makefile b/Makefile
index 1a60bdd..c6e6859 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 17
 SUBLEVEL = 0
-EXTRAVERSION = -rc4
+EXTRAVERSION = -eudyptula
 NAME = Shuffling Zombie Juror
 
 # *DOCUMENTATION*
--


