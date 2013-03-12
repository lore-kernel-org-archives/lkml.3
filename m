Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab3CLKmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:42:32 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:42903 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754556Ab3CLKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:42:29 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v3 0/4] Cosmetic changes to the android binder proc release code
Date: Tue, 12 Mar 2013 11:41:58 +0100
Message-Id: <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
References: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These are cleanup patches related to the binder_deferred_release function
in the android binder staging driver which improve readability while removing
checkpatch and compiler warnings.

 drivers/staging/android/binder.c |  138 +++++++++++++++++-----------
 1 file changed, 84 insertions(+), 54 deletions(-)

Changes from v1:

 * squashed patches 3 and 4 together instead of introducing a warning
   in patch 3 then fix it in patch 4. (Following Joe Perches' review)
 * removed the extra nd_refs variable from patch 1 and fixed whitespace
   in patch 2 (Following Dan Carpenter's reviews)
 * renamed the new binder_node_release_deferred function to a shorter
   binder_node_release as releasing a node will allways be deferred

Changes from v2

 * kept arguments aligned with parentesis (Following
   Arve Hjønnevåg's review)
 * added a fourth patch which removes function names from string litterals
   in favor __func__ (Following Dan Carpenter's review)
 * improved commit log messages slightly

Please excuse my wasting of your time for such trivia.
I do want to get the basics of submitting patches right
before starting any heavier lifting.

Thank you for your time and sorry again for the noise,
Best regards,

--
mirsal

