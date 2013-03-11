Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3CKX1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:27:41 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:53869 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754427Ab3CKX0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:26:52 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2 0/3] Cosmetic changes to the android binder proc release code
Date: Tue, 12 Mar 2013 00:26:25 +0100
Message-Id: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These are cleanup patches related to the binder_deferred_release function
in the android binder staging driver which improve readability while removing
checkpatch and compiler warnings.

 drivers/staging/android/binder.c |  137 +++++++++++++++++-----------
 1 file changed, 85 insertions(+), 52 deletions(-)

Changes from v1:

 * squashed patches 3 and 4 together instead of introducing a warning
   in patch 3 and then fix it in patch 4. (Following Joe Perches' review)
 * removed the extra nd_refs variable from patch 1 and fixed whitespace
   in patch 2 (Following Dan Carpenter's reviews)

Thank you for your time and sorry again for the noise,
Best regards,

--
mirsal

