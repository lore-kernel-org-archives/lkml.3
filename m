Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaENXyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:54:01 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59414 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaENXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:54:00 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH] staging: lustre: socklnd: Add a required space
Date: Thu, 15 May 2014 00:53:38 +0100
Message-Id: <1400111618-7409-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a required space before open brace and parenthsis
in socklnd.c to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..adcd688 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -1571,7 +1571,7 @@ ksocknal_terminate_conn (ksock_conn_t *conn)
 	conn->ksnc_tx_ready = 1;
 
 	if (!conn->ksnc_tx_scheduled &&
-	    !list_empty(&conn->ksnc_tx_queue)){
+	    !list_empty(&conn->ksnc_tx_queue)) {
 		list_add_tail (&conn->ksnc_tx_list,
 			       &sched->kss_tx_conns);
 		conn->ksnc_tx_scheduled = 1;
@@ -2098,7 +2098,7 @@ ksocknal_ctl(lnet_ni_t *ni, unsigned int cmd, void *arg)
 	struct libcfs_ioctl_data *data = arg;
 	int rc;
 
-	switch(cmd) {
+	switch (cmd) {
 	case IOC_LIBCFS_GET_INTERFACE: {
 		ksock_net_t       *net = ni->ni_data;
 		ksock_interface_t *iface;
-- 
1.7.9.5

