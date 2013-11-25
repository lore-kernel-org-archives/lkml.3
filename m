Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3KYSRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:17:53 -0500
Received: from ring0.de ([91.143.88.219]:38056 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757626Ab3KYSRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:17:46 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH] MAINTAINERS: add HSI subsystem
Date: Mon, 25 Nov 2013 19:17:30 +0100
Message-Id: <1385403450-18018-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds me as maintainer for the HSI subsystem and
Carlos Chinea (original author) to the CREDITS file.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
Hi,

Please check [0] for more details of the work I did and plan to do.
I'm interested in a Co-Maintainer. I plan to setup a git repository
for the hsi tree on kernel.org, but my account request is stalled,
since I'm currently not listed in the MAINTAINERS file.

[0] https://lkml.org/lkml/2013/10/10/504

-- Sebastian
---
 CREDITS     | 5 +++++
 MAINTAINERS | 8 ++++++++
 2 files changed, 13 insertions(+)

diff --git a/CREDITS b/CREDITS
index 4fc997d..4c7738f 100644
--- a/CREDITS
+++ b/CREDITS
@@ -655,6 +655,11 @@ S: Stanford University
 S: Stanford, California 94305
 S: USA
 
+N: Carlos Chinea
+E: carlos.chinea@nokia.com
+E: cch.devel@gmail.com
+D: Author of HSI Subsystem
+
 N: Randolph Chung
 E: tausq@debian.org
 D: Linux/PA-RISC hacker
diff --git a/MAINTAINERS b/MAINTAINERS
index f216db8..5629a41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4043,6 +4043,14 @@ W:	http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi
 S:	Maintained
 F:	fs/hpfs/
 
+HSI SUBSYSTEM
+M:	Sebastian Reichel <sre@debian.org>
+S:	Maintained
+F:	Documentation/hsi/
+F:	drivers/hsi/
+F:	include/linux/hsi/
+F:	include/uapi/linux/hsi/
+
 HSO 3G MODEM DRIVER
 M:	Jan Dumon <j.dumon@option.com>
 W:	http://www.pharscape.org
-- 
1.8.4.3

