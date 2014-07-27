Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaG0T4o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 15:56:44 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:39390 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaG0T4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 15:56:43 -0400
Date: Sun, 27 Jul 2014 20:56:38 +0100
From: "Liviu I." <liviu.i.2222@gmail.com>
To: gregkh@linuxfoundation.org, amk@cray.com, liang.zhen@intel.com,
        uja.ornl@gmail.com, emoly.liu@intel.com, rashika.kheria@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Eudyptula Challenge (Task 10)
Message-ID: <20140727195637.GA23931@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Kernel Developers!

I've attached a small patch to fix a coding style problem and make checkpatch happy, as part of challenge 10 of Eudyptula.

Thank you

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

--- drivers/staging/lustre/lustre/ldlm/ldlm_extent.c.orig	2014-07-27 20:26:53.714161698 +0100
+++ drivers/staging/lustre/lustre/ldlm/ldlm_extent.c	2014-07-27 20:27:50.410159692 +0100
@@ -151,7 +151,8 @@ static inline int lock_mode_to_index(ldl
 
 	LASSERT(mode != 0);
 	LASSERT(IS_PO2(mode));
-	for (index = -1; mode; index++, mode >>= 1) ;
+	for (index = -1; mode; index++, mode >>= 1)
+		;
 	LASSERT(index < LCK_MODE_NUM);
 	return index;
 }

--HcAYCG3uE/tztfnV--
