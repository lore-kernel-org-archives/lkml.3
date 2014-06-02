Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaFBCUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:20:12 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59716 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaFBCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:20:10 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 3/3] staging: vt6655: fix sparse warning for static declarations
Date: Sun,  1 Jun 2014 22:19:33 -0400
Message-Id: <1401675573-27734-3-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401675573-27734-2-git-send-email-shack@linux.com>
References: <1401675573-27734-1-git-send-email-shack@linux.com>
 <1401675573-27734-2-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings:

iwctl.c:76:22: warning: symbol 'iwctl_get_wireless_stats' was not declared. Should it be static?
iwctl.c:118:5: warning: symbol 'iwctl_giwname' was not declared. Should it be static?
iwctl.c:131:5: warning: symbol 'iwctl_siwscan' was not declared. Should it be static?
iwctl.c:192:5: warning: symbol 'iwctl_giwscan' was not declared. Should it be static?
iwctl.c:344:5: warning: symbol 'iwctl_siwfreq' was not declared. Should it be static?
iwctl.c:390:5: warning: symbol 'iwctl_giwfreq' was not declared. Should it be static?
iwctl.c:420:5: warning: symbol 'iwctl_siwmode' was not declared. Should it be static?
iwctl.c:486:5: warning: symbol 'iwctl_giwmode' was not declared. Should it be static?
iwctl.c:520:5: warning: symbol 'iwctl_giwrange' was not declared. Should it be static?
iwctl.c:626:5: warning: symbol 'iwctl_siwap' was not declared. Should it be static?
iwctl.c:684:5: warning: symbol 'iwctl_giwap' was not declared. Should it be static?
iwctl.c:711:5: warning: symbol 'iwctl_giwaplist' was not declared. Should it be static?
iwctl.c:784:5: warning: symbol 'iwctl_siwessid' was not declared. Should it be static?
iwctl.c:893:5: warning: symbol 'iwctl_giwessid' was not declared. Should it be static?
iwctl.c:923:5: warning: symbol 'iwctl_siwrate' was not declared. Should it be static?
iwctl.c:1004:5: warning: symbol 'iwctl_giwrate' was not declared. Should it be static?
iwctl.c:1049:5: warning: symbol 'iwctl_siwrts' was not declared. Should it be static?
iwctl.c:1077:5: warning: symbol 'iwctl_giwrts' was not declared. Should it be static?
iwctl.c:1096:5: warning: symbol 'iwctl_siwfrag' was not declared. Should it be static?
iwctl.c:1123:5: warning: symbol 'iwctl_giwfrag' was not declared. Should it be static?
iwctl.c:1141:5: warning: symbol 'iwctl_siwretry' was not declared. Should it be static?
iwctl.c:1176:5: warning: symbol 'iwctl_giwretry' was not declared. Should it be static?
iwctl.c:1205:5: warning: symbol 'iwctl_siwencode' was not declared. Should it be static?
iwctl.c:1336:5: warning: symbol 'iwctl_giwencode' was not declared. Should it be static?
iwctl.c:1398:5: warning: symbol 'iwctl_siwpower' was not declared. Should it be static?
iwctl.c:1448:5: warning: symbol 'iwctl_giwpower' was not declared. Should it be static?
iwctl.c:1478:5: warning: symbol 'iwctl_giwsens' was not declared. Should it be static?
iwctl.c:1502:5: warning: symbol 'iwctl_siwauth' was not declared. Should it be static?
iwctl.c:1603:5: warning: symbol 'iwctl_giwauth' was not declared. Should it be static?
iwctl.c:1611:5: warning: symbol 'iwctl_siwgenie' was not declared. Should it be static?
iwctl.c:1644:5: warning: symbol 'iwctl_giwgenie' was not declared. Should it be static?
iwctl.c:1669:5: warning: symbol 'iwctl_siwencodeext' was not declared. Should it be static?
iwctl.c:1783:5: warning: symbol 'iwctl_giwencodeext' was not declared. Should it be static?
iwctl.c:1791:5: warning: symbol 'iwctl_siwmlme' was not declared. Should it be static?
iwctl.c:1900:21: warning: symbol 'iwctl_private_args' was not declared. Should it be static?
iwctl.c:1906:33: warning: symbol 'iwctl_handler_def' was not declared. Should it be static?

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/vt6655/iwctl.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index ae2b87f..ba50d7f 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -33,6 +33,7 @@
 #include "device.h"
 #include "ioctl.h"
 #include "iocmd.h"
+#include "iwctl.h"
 #include "mac.h"
 #include "card.h"
 #include "hostap.h"
-- 
1.7.9.5

