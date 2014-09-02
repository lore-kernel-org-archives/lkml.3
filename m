Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaIBQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:40:33 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45407 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBQkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:40:32 -0400
From: Mathieu OTHACEHE <m.othacehe@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com, bergwolf@gmail.com, toby@tismith.id.au
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mathieu OTHACEHE <m.othacehe@gmail.com>
Subject: [PATCH] staging: lustre: Fix space prohibited between function name and open parenthesis
Date: Tue,  2 Sep 2014 18:39:44 +0200
Message-Id: <1409675984-2712-1-git-send-email-m.othacehe@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning in lnet/lnet/lib-eq.c:
WARNING: space prohibited between function name and open parenthesis '('

Signed-off-by: Mathieu OTHACEHE <m.othacehe@gmail.com>
---
This patch is part of task 10 of the eudyptula challenge
 drivers/staging/lustre/lnet/lnet/lib-eq.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index bd45478..6c04842 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -72,8 +72,8 @@ LNetEQAlloc(unsigned int count, lnet_eq_handler_t callback,
 {
 	lnet_eq_t     *eq;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	/* We need count to be a power of 2 so that when eq_{enq,deq}_seq
 	 * overflow, they don't skip entries, so the queue has the same
@@ -287,7 +287,7 @@ lnet_eq_dequeue_event(lnet_eq_t *eq, lnet_event_t *ev)
  * EQ has been dropped due to limited space in the EQ.
  */
 int
-LNetEQGet (lnet_handle_eq_t eventq, lnet_event_t *event)
+LNetEQGet(lnet_handle_eq_t eventq, lnet_event_t *event)
 {
 	int which;
 
@@ -313,7 +313,7 @@ EXPORT_SYMBOL(LNetEQGet);
  * EQ has been dropped due to limited space in the EQ.
  */
 int
-LNetEQWait (lnet_handle_eq_t eventq, lnet_event_t *event)
+LNetEQWait(lnet_handle_eq_t eventq, lnet_event_t *event)
 {
 	int which;
 
@@ -400,8 +400,8 @@ LNetEQPoll(lnet_handle_eq_t *eventqs, int neq, int timeout_ms,
 	int	rc;
 	int	i;
 
-	LASSERT (the_lnet.ln_init);
-	LASSERT (the_lnet.ln_refcount > 0);
+	LASSERT(the_lnet.ln_init);
+	LASSERT(the_lnet.ln_refcount > 0);
 
 	if (neq < 1)
 		return -ENOENT;
-- 
2.1.0

