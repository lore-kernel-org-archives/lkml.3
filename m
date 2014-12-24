Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaLXEH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 23:07:56 -0500
Received: from mail-pa0-f68.google.com ([209.85.220.68]:42621 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaLXEHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 23:07:54 -0500
From: "Panir.Nyan" <panir.nyan@gmail.com>
X-Google-Original-From: "Panir.Nyan" <Panir.Nyan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Panir.Nyan" <Panir.Nyan@gmail.com>
Subject: [PATCH 2/2] staging: speakup: Combine the consecutive string
Date: Wed, 24 Dec 2014 04:07:32 +0000
Message-Id: <1419394052-6551-2-git-send-email-Panir.Nyan@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
References: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine the consecutive string

Signed-off-by: Panir Nyan <Panir.Nyan@gmail.com>
---
 drivers/staging/speakup/kobjects.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/kobjects.c b/drivers/staging/speakup/kobjects.c
index b12c76d..3708bc1 100644
--- a/drivers/staging/speakup/kobjects.c
+++ b/drivers/staging/speakup/kobjects.c
@@ -566,7 +566,7 @@ ssize_t spk_var_show(struct kobject *kobj, struct kobj_attribute *attr,
 				if (ch >= ' ' && ch < '~')
 					*cp1++ = ch;
 				else
-					cp1 += sprintf(cp1, "\\""x%02x", ch);
+					cp1 += sprintf(cp1, "\\x%02x", ch);
 			}
 			*cp1++ = '"';
 			*cp1++ = '\n';
--
1.7.10.4

