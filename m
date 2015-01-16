Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbbAPBzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:55:52 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:61008 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbbAPBzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:55:45 -0500
From: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        jon.nettleton@gmail.com, dsd@laptop.org, jfrederich@gmail.com,
        Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Subject: [PATCH 2/2] staging: olpc_dcon: fix sparse symbol not declared warning
Date: Thu, 15 Jan 2015 23:55:00 -0200
Message-Id: <1421373300-13672-3-git-send-email-mopsfelder@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
References: <1421373300-13672-1-git-send-email-mopsfelder@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch gets rid of the following sparse warning:

drivers/staging/olpc_dcon/olpc_dcon.c:787:19: warning: symbol 'dcon_driver' was not declared. Should it be static?

Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
---
 drivers/staging/olpc_dcon/olpc_dcon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c b/drivers/staging/olpc_dcon/olpc_dcon.c
index 3708f1e..4ec2a9c 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.c
+++ b/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -784,7 +784,7 @@ static const struct i2c_device_id dcon_idtable[] = {
 };
 MODULE_DEVICE_TABLE(i2c, dcon_idtable);
 
-struct i2c_driver dcon_driver = {
+static struct i2c_driver dcon_driver = {
 	.driver = {
 		.name	= "olpc_dcon",
 		.pm = &dcon_pm_ops,
-- 
2.1.0

