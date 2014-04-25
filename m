Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaDYEGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 00:06:50 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:62614 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaDYEGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 00:06:49 -0400
Message-ID: <5359DF54.50607@gmail.com>
Date: Fri, 25 Apr 2014 01:06:44 -0300
From: Nicolas Del Piano <ndel314@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, mail@berndporr.me.uk,
        devel@driverdev.osuosl.org
Subject: [PATCH] Staging: comedi: drivers: fixed a  coding style issue.
Content-Type: multipart/mixed;
 boundary="------------020301010204060000080102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020301010204060000080102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------020301010204060000080102
Content-Type: text/x-patch;
 name="0001-Staging-comedi-drivers-fixed-a-missing-blank-line-af.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Staging-comedi-drivers-fixed-a-missing-blank-line-af.pa";
 filename*1="tch"

>From 38e0d5778bd97062115e7d8a8ca40d18f3d71707 Mon Sep 17 00:00:00 2001
From: Nicolas Del Piano <ndel314@gmail.com>
Date: Thu, 24 Apr 2014 18:46:49 -0300
Subject: [PATCH] Staging: comedi: drivers: fixed a missing blank line after a
 declaration coding style.

Fixed a coding style issue.

Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
---
 drivers/staging/comedi/drivers.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index cb5d214..71569bc 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -439,6 +439,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
 static void comedi_report_boards(struct comedi_driver *driv)
 {
 	unsigned int i;
+
 	const char *const *name_ptr;
 
 	pr_info("comedi: valid board names for %s driver are:\n",
-- 
1.7.9.5


--------------020301010204060000080102--
