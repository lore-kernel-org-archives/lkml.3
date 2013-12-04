Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3LDVN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:13:56 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:58075 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3LDVNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:13:55 -0500
Date: Wed, 4 Dec 2013 21:13:48 +0000
From: Samuel Dominguez <samuel.dominguez.lorenzo@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lnet: lnet: fixed space coding style issues
Message-ID: <20131204211348.GB5225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 187369f55f9f9bc58c87fc1ac118143db5735033 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Samuel=20Dom=C3=ADnguez?=
 <samuel.dominguez.lorenzo@gmail.com>
Date: Wed, 4 Dec 2013 20:35:41 +0000
Subject: [PATCH] staging: lustre: lnet: lnet: fixed space coding style issues

Fixed a coding style issue.

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
        int             rc;
        int             status = msg->msg_ev.status;

-       LASSERT (msg->msg_onactivelist);
+       LASSERT(msg->msg_onactivelist);

        if (status == 0 && msg->msg_ack) {
                /* Only send an ACK if the PUT completed successfully */
@@ -432,7 +432,7 @@ lnet_complete_msg_locked(lnet_msg_t *msg, int cpt)
 }

 void
-lnet_finalize (lnet_ni_t *ni, lnet_msg_t *msg, int status)
+lnet_finalize(lnet_ni_t *ni, lnet_msg_t *msg, int status)
 {
        struct lnet_msg_container       *container;
        int                             my_slot;
@@ -440,7 +440,7 @@ lnet_finalize (lnet_ni_t *ni, lnet_msg_t *msg, int status)
        int                             rc;
        int                             i;

-       LASSERT (!in_interrupt ());
+       LASSERT(!in_interrupt());

        if (msg == NULL)
                return;
--
1.8.3.2
