Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFMFy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:54:56 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56705 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaFMFyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:54:55 -0400
From: Jimmy Picard <jimmyp11f155@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jimmy Picard <jimmyp11f155@gmail.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: iio: fix coding style
Date: Fri, 13 Jun 2014 13:56:01 +0800
Message-Id: <1402638961-14176-1-git-send-email-jimmyp11f155@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coding style reported by checkpatch.pl that missing
a blank line after declarations.

Signed-off-by: Jimmy Picard <jimmyp11f155@gmail.com>
---
 drivers/staging/iio/iio_simple_dummy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/iio/iio_simple_dummy.c b/drivers/staging/iio/iio_simple_dummy.c
index fd334a0..bf78e6f 100644
--- a/drivers/staging/iio/iio_simple_dummy.c
+++ b/drivers/staging/iio/iio_simple_dummy.c
@@ -550,6 +550,7 @@ error_ret:
 static __init int iio_dummy_init(void)
 {
 	int i, ret;
+
 	if (instances > 10) {
 		instances = 1;
 		return -EINVAL;
@@ -577,6 +578,7 @@ module_init(iio_dummy_init);
 static __exit void iio_dummy_exit(void)
 {
 	int i;
+
 	for (i = 0; i < instances; i++)
 		iio_dummy_remove(i);
 	kfree(iio_dummy_devs);
-- 
2.0.0

