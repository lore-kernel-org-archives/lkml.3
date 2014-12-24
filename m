Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaLXEHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 23:07:49 -0500
Received: from mail-pa0-f68.google.com ([209.85.220.68]:59186 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLXEHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 23:07:48 -0500
From: "Panir.Nyan" <panir.nyan@gmail.com>
X-Google-Original-From: "Panir.Nyan" <Panir.Nyan@gmail.com>
To: gregkh@linuxfoundation.org
Cc: w.d.hubbs@gmail.com, chris@the-brannons.com, kirk@reisers.ca,
        samuel.thibault@ens-lyon.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Panir.Nyan" <Panir.Nyan@gmail.com>
Subject: [PATCH 1/2] staging: speakup: Split the comment to fit the length
Date: Wed, 24 Dec 2014 04:07:31 +0000
Message-Id: <1419394052-6551-1-git-send-email-Panir.Nyan@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the comment to fit the length.

Signed-off-by: Panir Nyan <Panir.Nyan@gmail.com>
---
 drivers/staging/speakup/synth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/speakup/synth.c b/drivers/staging/speakup/synth.c
index f3aa423..01eddab 100644
--- a/drivers/staging/speakup/synth.c
+++ b/drivers/staging/speakup/synth.c
@@ -30,9 +30,9 @@ struct speakup_info_t speakup_info = {
 	 * must be taken at each kernel->speakup transition and released at
 	 * each corresponding speakup->kernel transition.
 	 *
-	 * The progression thread only interferes with the speakup machinery through
-	 * the synth buffer, so only needs to take the lock while tinkering with
-	 * the buffer.
+	 * The progression thread only interferes with the speakup machinery
+	 * through the synth buffer, so only needs to take the lock
+	 * while tinkering with the buffer.
 	 *
 	 * We use spin_lock/trylock_irqsave and spin_unlock_irqrestore with this
 	 * spinlock because speakup needs to disable the keyboard IRQ.
--
1.7.10.4

