Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3AYKge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:36:34 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:35396 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab3AYKg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:36:29 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH 1/2] media: add chip id for THS7353
Date: Fri, 25 Jan 2013 16:06:06 +0530
Message-Id: <1359110167-5703-2-git-send-email-prabhakar.lad@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359110167-5703-1-git-send-email-prabhakar.lad@ti.com>
References: <1359110167-5703-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manjunath Hadli <manjunath.hadli@ti.com>

add chip id for THS7353 amplifier.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 include/media/v4l2-chip-ident.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
index 2fa9e17..2d140a5 100644
--- a/include/media/v4l2-chip-ident.h
+++ b/include/media/v4l2-chip-ident.h
@@ -177,6 +177,9 @@ enum {
 	/* module ths7303: just ident 7303 */
 	V4L2_IDENT_THS7303 = 7303,
 
+	/* module ths7353: just ident 7353 */
+	V4L2_IDENT_THS7353 = 7353,
+
 	/* module adv7343: just ident 7343 */
 	V4L2_IDENT_ADV7343 = 7343,
 
-- 
1.7.4.1

