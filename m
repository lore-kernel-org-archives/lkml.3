Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaKRMWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:22:48 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:62826 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbaKRMWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:22:44 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-tegra@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        mikko.perttunen@kapsi.fi, acourbot@nvidia.com,
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
Subject: [PATCH v5 02/14] of: Document long-ram-code property in nvidia,tegra20-apbmisc
Date: Tue, 18 Nov 2014 13:13:04 +0100
Message-Id: <1416312860-4446-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
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

