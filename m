Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaJUXg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:36:59 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45221 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaJUXg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:36:57 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: jaswinder.singh@linaro.org, linux-kernel@vger.kernel.org, corbet@lwn.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: Fix a typo in mailbox.txt
Date: Wed, 22 Oct 2014 08:36:07 +0900
Message-Id: <1413934567-1207-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.2.451.g98349e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a typo in Documentation/mailbox.txt
"bool async" is defined in struct demo_client.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/mailbox.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mailbox.txt b/Documentation/mailbox.txt
index 60f43ff..1092ad9 100644
--- a/Documentation/mailbox.txt
+++ b/Documentation/mailbox.txt
@@ -53,7 +53,7 @@ static void message_from_remote(struct mbox_client *cl, void *mssg)
 {
 	struct demo_client *dc = container_of(mbox_client,
 						struct demo_client, cl);
-	if (dc->aysnc) {
+	if (dc->async) {
 		if (is_an_ack(mssg)) {
 			/* An ACK to our last sample sent */
 			return; /* Or do something else here */
-- 
2.1.2.451.g98349e5

