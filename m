Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016AbaFLOi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:38:26 -0400
Received: from blu004-omc1s25.hotmail.com ([65.55.116.36]:54762 "EHLO
	BLU004-OMC1S25.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752898AbaFLOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:38:25 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 10:38:25 EDT
X-TMN: [0omWdM6/vVAC1oMzNmu+9CvNAhl8U2gd]
X-Originating-Email: [nickkrause@sympatico.ca]
Message-ID: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
Subject: Re: PATCH[[vme/bridges/vme_ca91cx42.c:1382: Bad if test Bug
 =?UTF-8?Q?Fix=5D=E2=80=8F=E2=80=8F?=
From: nick <nickkrause@sympatico.ca>
To: martyn.welch@ge.com
CC: manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 10:33:09 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2014 14:33:17.0093 (UTC) FILETIME=[3FF82550:01CF864B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the fixed patch. Having issues with using Thunderbird
so just used Evolution for now.
Nick 
--- drivers/vme/bridges/vme_ca91cx42.h.orig	2014-06-11 22:50:29.339671939 -0400
+++ drivers/vme/bridges/vme_ca91cx42.h	2014-06-11 23:15:36.027685173 -0400
Fixes bug issues with wrong bus width in if statments in vme_ca91cx42.c
Signed-off-by: Nicholas Krause <nickkrause@sympatico.ca>
@@ -526,7 +526,7 @@ static const int CA91CX42_LINT_LM[] = {
 #define CA91CX42_VSI_CTL_SUPER_SUPR	(1<<21)
 
 #define CA91CX42_VSI_CTL_VAS_M		(7<<16)
-#define CA91CX42_VSI_CTL_VAS_A16	0
+#define CA91CX42_VSI_CTL_VAS_A16	(3<<16)
 #define CA91CX42_VSI_CTL_VAS_A24	(1<<16)
 #define CA91CX42_VSI_CTL_VAS_A32	(1<<17)
 #define CA91CX42_VSI_CTL_VAS_USER1	(3<<17)
@@ -549,7 +549,7 @@ static const int CA91CX42_LINT_LM[] = {
 #define CA91CX42_LM_CTL_SUPR		(1<<21)
 #define CA91CX42_LM_CTL_NPRIV		(1<<20)
 #define CA91CX42_LM_CTL_AS_M		(5<<16)
-#define CA91CX42_LM_CTL_AS_A16		0
+#define CA91CX42_LM_CTL_AS_A16		(3<<16)
 #define CA91CX42_LM_CTL_AS_A24		(1<<16)
 #define CA91CX42_LM_CTL_AS_A32		(1<<17)



