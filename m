Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaFLDtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:49:42 -0400
Received: from snt004-omc3s21.hotmail.com ([65.55.90.160]:49328 "EHLO
	SNT004-OMC3S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755270AbaFLDtl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:49:41 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2014 23:49:41 EDT
X-TMN: [I37tkGc9FHCU2HDwIFD82b47O6/HATIP]
X-Originating-Email: [nickkrause@sympatico.ca]
Message-ID: <SNT145-W91D1F7437CE550B912FD99A52A0@phx.gbl>
From: Nick Krause <nickkrause@sympatico.ca>
To: "martyn.welch@ge.com" <martyn.welch@ge.com>
CC: "manohar.vanga@gmail.com" <manohar.vanga@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: PATCH[vme/bridges/vme_ca91cx42.c:1382: Bad if test Bug Fix]
Date: Thu, 12 Jun 2014 03:44:34 +0000
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 Jun 2014 03:44:35.0122 (UTC) FILETIME=[A0AAB120:01CF85F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Fellow Developers, 
This is my first patch so if there are any errors please reply as i will 
fix them. Below is the patch.
-- drivers/vme/bridges/vme_ca91cx42.h.orig    2014-06-11 22:50:29.339671939 -0400
+++ drivers/vme/bridges/vme_ca91cx42.h    2014-06-11 23:15:36.027685173 -0400
@@ -526,7 +526,7 @@ static const int CA91CX42_LINT_LM[] = {
 #define CA91CX42_VSI_CTL_SUPER_SUPR    (1<<21)
 
 #define CA91CX42_VSI_CTL_VAS_M        (7<<16)
-#define CA91CX42_VSI_CTL_VAS_A16    0
+#define CA91CX42_VSI_CTL_VAS_A16    (3<<16)
 #define CA91CX42_VSI_CTL_VAS_A24    (1<<16)
 #define CA91CX42_VSI_CTL_VAS_A32    (1<<17)
 #define CA91CX42_VSI_CTL_VAS_USER1    (3<<17)
@@ -549,7 +549,7 @@ static const int CA91CX42_LINT_LM[] = {
 #define CA91CX42_LM_CTL_SUPR        (1<<21)
 #define CA91CX42_LM_CTL_NPRIV        (1<<20)
 #define CA91CX42_LM_CTL_AS_M        (5<<16)
-#define CA91CX42_LM_CTL_AS_A16        0
+#define CA91CX42_LM_CTL_AS_A16        (3<<16)
 #define CA91CX42_LM_CTL_AS_A24        (1<<16)
 #define CA91CX42_LM_CTL_AS_A32        (1<<17)
Signed-off-by: Nicholas Krause <nickkrause@sympatico.ca>
Nick
 		 	   		  