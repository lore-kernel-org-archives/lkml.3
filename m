Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaFNPhO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:37:14 -0400
Received: from ring0.de ([5.45.105.125]:40273 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbaFNPhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:37:10 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH] MAINTAINERS: power_supply: update maintainership
Date: Sat, 14 Jun 2014 17:32:09 +0200
Message-Id: <1402759929-15418-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1946020.rieJTheGae@vostro.rjw.lan>
References: <1946020.rieJTheGae@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take over maintanence for orphaned power supply subsystem
and move the git tree to a new kernel.org based repository.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
Hi,

As suggested by Rafael in [0] I volunteer to take over the orphaned
power supply subsystem.

[0] http://www.spinics.net/lists/kernel/msg1744793.html

-- Sebastian
---
 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c484ac..54d9cbf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6928,9 +6928,8 @@ F:	include/linux/timer*
 F:	kernel/*timer*
 
 POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
-M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
-M:	David Woodhouse <dwmw2@infradead.org>
-T:	git git://git.infradead.org/battery-2.6.git
+M:	Sebastian Reichel <sre@kernel.org>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-power-supply.git
 S:	Maintained
 F:	include/linux/power_supply.h
 F:	drivers/power/
-- 
2.0.0

