Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaGHQhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:37:42 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:19110 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbaGHQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:37:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OAIcdvFNXQDwH/2dsb2JhbABZgw6tGwUBAQEBAQEFAW4BmVmBGBd1hQOBAhg3iC4DFQHDWA2GFIV6hx6BRmQdhC0FmHaCAI14hhSDRTuBMQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 1/1] input: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 18:37:36 +0200
Message-Id: <1404837456-7321-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/input/misc/keyspan_remote.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/misc/keyspan_remote.c b/drivers/input/misc/keyspan_remote.c
index 01f3b5b..a3fe4a9 100644
--- a/drivers/input/misc/keyspan_remote.c
+++ b/drivers/input/misc/keyspan_remote.c
@@ -392,7 +392,6 @@ static void keyspan_irq_recv(struct urb *urb)
 
 	default:
 		goto resubmit;
-		break;
 	}
 
 	if (debug)
-- 
1.8.4.5

