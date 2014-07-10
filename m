Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaGJMNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:13:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39200 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaGJMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:13:12 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>
Subject: [PATCH v4 0/4] staging: rtl8192u: checkpatch fixes
Date: Thu, 10 Jul 2014 17:54:53 +0530
Message-Id: <1404995097-12689-1-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20140708100142.GR25934@mwanda>
References: <20140708100142.GR25934@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

This version of patch incorporated Joe & Greg KH review comment.

sanjeev sharma (4):
  staging: rtl8192u: Remove useless return statement
  staging: rtl8192u: Removed unnecessary whitespace & tab warning
  staging: rtl8192u: Fixed switch and case indentation error
  staging: rtl8192u: Fixed too long line

 drivers/staging/rtl8192u/r819xU_phy.c | 57 +++++++++++++++--------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

-- 
1.7.11.7

