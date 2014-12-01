Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932787AbaLAWMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:12:08 -0500
Received: from relay07.alfahosting-server.de ([109.237.142.243]:44459 "EHLO
	relay07.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932564AbaLAWMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:12:05 -0500
X-Greylist: delayed 620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Dec 2014 17:12:05 EST
X-Spam-DCC: : 
Date: Mon, 1 Dec 2014 23:02:08 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/email-clients.txt: add info about Claws Mail
Message-ID: <20141201230208.4567b6cc@frodo>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19707/Mon Dec  1 19:14:05 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Claws Mail GUI client works when "Auto wrapping" is disabled.

Signed-off-by: Richard Leitner <dev@g0hl1n.net>
---
 Documentation/email-clients.txt | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 9af538be..1f8929e 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -77,6 +77,15 @@ should appear, and then pressing CTRL-R let you specify the patch file
 to insert into the message.
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Claws Mail (GUI)
+
+Some people use this successfully for patches.
+
+Just turn off Auto wrapping in Configuration->Preferences->Compose->Wrapping
+
+To insert a patch use Message->Insert File (CTRL+i) or an external editor.
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Evolution (GUI)
 
 Some people use this successfully for patches.
-- 
2.1.3

