Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaGIFwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:52:35 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54907 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIFwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:52:34 -0400
From: sanjeev sharma <sanjeevsharmaengg@gmail.com>
To: gregkh@linuxfoundation.org
Cc: rmfrfs@gmail.com, peter.senna@gmail.com, teobaluta@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        sanjeev sharma <sanjeev_sharma@mentor.com>
Subject: [PATCH v2 0/4] Fix checkpatch reported problem in r819xU_phy.c
Date: Wed,  9 Jul 2014 11:34:16 +0530
Message-Id: <1404885860-19468-1-git-send-email-sanjeevsharmaengg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20140708100142.GR25934@mwanda>
References: <20140708100142.GR25934@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: sanjeev sharma <sanjeev_sharma@mentor.com>

I have come up with seperate patch as per Dan comment.

sanjeev sharma (4):
  staging: rtl8192u: Remove useless return statement in r819xU_phy.c
  staging: rtl8192u: Removed unnecessary whitespace & tab warning  in
    r819xU_phy.c
  staging: rtl8192u: Fixed switch and case indentation error in
    r819xU_phy.c
  staging: rtl8192u: Fixed too long lines in r819xU_phy.c

 drivers/staging/rtl8192u/r819xU_phy.c | 58 +++++++++++++++--------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

-- 
1.7.11.7

