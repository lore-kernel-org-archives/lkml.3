Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592AbaJ2Q1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:27:52 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33510 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaJ2QYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:24:08 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 02/13] of: Document long-ram-code property in nvidia,tegra20-apbmisc
Date: Wed, 29 Oct 2014 17:22:20 +0100
Message-Id: <1414599796-30597-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed to properly decode the ram code register.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

---

v3:	* Clarify wording as suggested by Mikko
---
 Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
index b97b8be..d034ff8 100644
--- a/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
+++ b/Documentation/devicetree/bindings/misc/nvidia,tegra20-apbmisc.txt
@@ -11,3 +11,5 @@ Required properties:
        The second entry gives the physical address and length of the
        registers indicating the strapping options.
 
+Optional properties:
+- nvidia,long-ram-code: If present, the RAM code is long (4 bit). If not, short (2 bit).
-- 
1.9.3

