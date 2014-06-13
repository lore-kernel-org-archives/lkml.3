Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaFMUls (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:41:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40454 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbaFMUlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:41:46 -0400
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Fri, 13 Jun 2014 21:41:34 +0100
Message-Id: <1402692095-23126-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.0
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] mailbox: Prototype mbox_client_peek_data()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

This is an interface intended for client drivers and exported but it is
not prototyped in the headers so can't be used. Add a prototype.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/mailbox_client.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mailbox_client.h b/include/linux/mailbox_client.h
index 53eb0784261b..cbfcf8478ca9 100644
--- a/include/linux/mailbox_client.h
+++ b/include/linux/mailbox_client.h
@@ -40,6 +40,7 @@ struct mbox_client {
 struct mbox_chan *mbox_request_channel(const struct mbox_client *cl);
 int mbox_send_message(struct mbox_chan *chan, void *mssg);
 void mbox_client_txdone(struct mbox_chan *chan, int r);
+bool mbox_client_peek_data(struct mbox_chan *chan);
 void mbox_free_channel(struct mbox_chan *chan);
 
 #endif /* __MAILBOX_CLIENT_H */
-- 
2.0.0

