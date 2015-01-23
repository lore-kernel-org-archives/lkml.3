Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbbAWRyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:54:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35933 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbbAWRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:53:59 -0500
From: jitendra kumar khasdev <jkhasdev@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pankaj.saraf@nektech.in, jitendra kumar khasdev <jkhasdev@gmail.com>
Subject: [PATCH 2/2] Staging: comedi: Fix warning line over 80 character
Date: Fri, 23 Jan 2015 23:23:22 +0530
Message-Id: <1422035602-17295-1-git-send-email-jkhasdev@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is patch to file ni_labpc_cs.c that fix warning line
over 80 character which is found by checkpatch tool.

Signed-off-by: Jitendra Kumar Khasdev <jkhasdev@gmail.com>
---
 drivers/staging/comedi/drivers/ni_labpc_cs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_cs.c b/drivers/staging/comedi/drivers/ni_labpc_cs.c
index 0a8b322..9858ab1 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_cs.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_cs.c
@@ -1,7 +1,8 @@
 /*
     comedi/drivers/ni_labpc_cs.c
     Driver for National Instruments daqcard-1200 boards
-    Copyright (C) 2001, 2002, 2003 Frank Mori Hess <fmhess@users.sourceforge.net>
+    Copyright (C) 2001, 2002, 2003 Frank Mori Hess
+    <fmhess@users.sourceforge.net>
 
     PCMCIA crap is adapted from dummy_cs.c 1.31 2001/08/24 12:13:13
     from the pcmcia package.
-- 
1.9.1

