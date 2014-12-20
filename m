Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaLTS3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:29:42 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62398 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbaLTS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:29:38 -0500
From: robert.ward114@googlemail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Rob Ward <robert.ward114@googlemail.com>
Subject: [PATCH 2/2] drivers: char: mem: Fix Missing blank line issues
Date: Sat, 20 Dec 2014 18:28:36 +0000
Message-Id: <1419100116-29819-3-git-send-email-robert.ward114@googlemail.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1419100116-29819-1-git-send-email-robert.ward114@googlemail.com>
References: <1419100116-29819-1-git-send-email-robert.ward114@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Ward <robert.ward114@googlemail.com>

Fixes "Missing a blank line after declarations" reported by
checkpatch.

This patch introduces no functional changes.

Signed-off-by: Rob Ward <robert.ward114@googlemail.com>
---
 drivers/char/mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a04ce78..6029d1f 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -575,6 +575,7 @@ static ssize_t write_port(struct file *file, const char __user *buf,
 		return -EFAULT;
 	while (count-- > 0 && i < 65536) {
 		char c;
+
 		if (__get_user(c, tmp)) {
 			if (tmp > buf)
 				break;
@@ -631,6 +632,7 @@ static ssize_t read_iter_zero(struct kiocb *iocb, struct iov_iter *iter)
 
 	while (iov_iter_count(iter)) {
 		size_t chunk = iov_iter_count(iter), n;
+
 		if (chunk > PAGE_SIZE)
 			chunk = PAGE_SIZE;	/* Just for latency reasons */
 		n = iov_iter_zero(chunk, iter);
-- 
2.0.2

