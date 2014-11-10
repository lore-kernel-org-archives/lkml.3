Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaKJUfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:35:34 -0500
Received: from ring0.de ([5.45.105.125]:52962 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaKJUfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:35:32 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv3 4/4] [media] si4713: cleanup platform data
Date: Mon, 10 Nov 2014 21:34:44 +0100
Message-Id: <1415651684-3894-5-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415651684-3894-1-git-send-email-sre@kernel.org>
References: <1415651684-3894-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unreferenced members from the platform
data's structure.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 include/media/si4713.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/media/si4713.h b/include/media/si4713.h
index 343b8fb5..be4f58e 100644
--- a/include/media/si4713.h
+++ b/include/media/si4713.h
@@ -23,9 +23,6 @@
  * Platform dependent definition
  */
 struct si4713_platform_data {
-	const char * const *supply_names;
-	unsigned supplies;
-	int gpio_reset; /* < 0 if not used */
 	bool is_platform_device;
 };
 
-- 
2.1.1

