Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab3LEQQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:16:25 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50204 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab3LEQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:16:22 -0500
From: Samuel Dominguez <samuel.dominguez.lorenzo@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Samuel=20Dom=C3=ADnguez?= 
	<samuel.dominguez.lorenzo@gmail.com>
Subject: [PATCH] staging: lustre: lnet: lnet: fixed space coding style issues
Date: Thu,  5 Dec 2013 16:16:13 +0000
Message-Id: <1386260173-4200-1-git-send-email-samuel.dominguez.lorenzo@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Domínguez <samuel.dominguez.lorenzo@gmail.com>

Fixed a coding style issue with spaces between function names and arguments:

func (x) -> func(x) 

Signed-off-by: Samuel Dominguez <samuel.dominguez.lorenzo@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-msg.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-msg.c b/drivers/staging/lustre/lnet/lnet/lib-msg.c
index 61ae88b..761f1e1 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-msg.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-msg.c
@@ -43,7 +43,7 @@
 #include <linux/lnet/lib-lnet.h>
 
 void
-lnet_build_unlink_event (lnet_libmd_t *md, lnet_event_t *ev)
+lnet_build_unlink_event(lnet_libmd_t *md, lnet_event_t *ev)
 {
 	memset(ev, 0, sizeof(*ev));
 
@@ -362,7 +362,7 @@ lnet_complete_msg_locked(lnet_msg_t *msg, int cpt)
 	int		rc;
 	int		status = msg->msg_ev.status;
 
-	LASSERT (msg->msg_onactivelist);
+	LASSERT(msg->msg_onactivelist);
 
 	if (status == 0 && msg->msg_ack) {
 		/* Only send an ACK if the PUT completed successfully */
@@ -432,7 +432,7 @@ lnet_complete_msg_locked(lnet_msg_t *msg, int cpt)
 }
 
 void
-lnet_finalize (lnet_ni_t *ni, lnet_msg_t *msg, int status)
+lnet_finalize(lnet_ni_t *ni, lnet_msg_t *msg, int status)
 {
 	struct lnet_msg_container	*container;
 	int				my_slot;
@@ -440,7 +440,7 @@ lnet_finalize (lnet_ni_t *ni, lnet_msg_t *msg, int status)
 	int				rc;
 	int				i;
 
-	LASSERT (!in_interrupt ());
+	LASSERT(!in_interrupt());
 
 	if (msg == NULL)
 		return;
-- 
1.8.3.2
