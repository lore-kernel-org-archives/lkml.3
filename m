Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665AbaLBQoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:44:14 -0500
Received: from relay02.alfahosting-server.de ([109.237.142.238]:36931 "EHLO
	relay02.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaLBQoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:44:12 -0500
X-Spam-DCC: : 
Date: Tue, 2 Dec 2014 17:44:36 +0100
From: Richard Leitner <dev@g0hl1n.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] Documentation/email-clients.txt: add info about Claws
 Mail
Message-ID: <20141202174436.0d624b0d@frodo>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/19710/Tue Dec  2 12:46:11 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Claws Mail GUI client works.
The client is available at http://www.claws-mail.org

Signed-off-by: Richard Leitner <dev@g0hl1n.net>
---
changes for v2: mention that disabling Auto wrapping is only needed when
                the patch has to be edited in the Claws composition window
---
 Documentation/email-clients.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 9af538be..eede608 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -77,6 +77,17 @@ should appear, and then pressing CTRL-R let you specify the patch file
 to insert into the message.
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Claws Mail (GUI)
+
+Works. Some people use this successfully for patches.
+
+To insert a patch use Message->Insert File (CTRL+i) or an external editor.
+
+If the inserted patch has to be edited in the Claws composition window
+"Auto wrapping" in Configuration->Preferences->Compose->Wrapping should be
+disabled.
+
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Evolution (GUI)
 
 Some people use this successfully for patches.
-- 
2.1.3


