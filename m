Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaC2AhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:37:25 -0400
Received: from ring0.de ([5.45.105.125]:42917 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbaC2Acq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:32:46 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 02/14] MAINTAINERS: update HSI entry
Date: Sat, 29 Mar 2014 01:31:38 +0100
Message-Id: <1396053110-21639-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add git tree for hsi subsystem, update Sebastian Reichel's e-mail
address and add Documentation/hsi.txt as maintained file.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 MAINTAINERS | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82640e6..b376b79 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4117,9 +4117,11 @@ S:	Maintained
 F:	fs/hpfs/
 
 HSI SUBSYSTEM
-M:	Sebastian Reichel <sre@debian.org>
+M:	Sebastian Reichel <sre@kernel.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git
 S:	Maintained
 F:	Documentation/ABI/testing/sysfs-bus-hsi
+F:	Documentation/hsi.txt
 F:	drivers/hsi/
 F:	include/linux/hsi/
 F:	include/uapi/linux/hsi/
-- 
1.9.0

