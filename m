Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3CKTl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:41:26 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:47707 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754254Ab3CKTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:41:23 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Cosmetic changes to the android binder proc release code
Date: Mon, 11 Mar 2013 20:31:51 +0100
Message-Id: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These are cleanup patches related to the binder_deferred_release function
in the android binder staging driver which improve readability while removing
checkpatch and compiler warnings.

 drivers/staging/android/binder.c |  121 +++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 44 deletions(-)

Hopefully I have submitted them correctly, this time :)

Thank you for your time and sorry for the noise,
Best regards,

-- 
mirsal


