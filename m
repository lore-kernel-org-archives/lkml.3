Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaJ0T3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:29:45 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:38843 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754382AbaJ0T2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:28:44 -0400
From: Feng Kan <fkan@apm.com>
To: catalin.marinas@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>, Vinayak Kale <vkale@apm.com>
Subject: [PATCH RESEND 6/7] Documentation: arm: pmu: Add Potenza PMU binding
Date: Mon, 27 Oct 2014 12:28:27 -0700
Message-Id: <1414438108-8384-7-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414438108-8384-1-git-send-email-fkan@apm.com>
References: <1414438108-8384-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents the compatible string for APM X-Gene Potenza CPU's PMU.

Signed-off-by: Vinayak Kale <vkale@apm.com>
Signed-off-by: Feng Kan <fkan@apm.com>
---
 Documentation/devicetree/bindings/arm/pmu.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/pmu.txt b/Documentation/devicetree/bindings/arm/pmu.txt
index 75ef91d..6d268b3 100644
--- a/Documentation/devicetree/bindings/arm/pmu.txt
+++ b/Documentation/devicetree/bindings/arm/pmu.txt
@@ -7,6 +7,7 @@ representation in the device tree should be done as under:-
 Required properties:
 
 - compatible : should be one of
+	"apm,potenza-pmu"
 	"arm,armv8-pmuv3"
 	"arm,cortex-a17-pmu"
 	"arm,cortex-a15-pmu"
-- 
1.9.1

