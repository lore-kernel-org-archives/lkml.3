Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbbAFQiC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:38:02 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42252 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbbAFQh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:37:58 -0500
From: mathieu.poirier@linaro.org
To: liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org, patches@linaro.org
Subject: [PATCH 9/9] coresight: Documenting reference to generic PD bindings
Date: Tue,  6 Jan 2015 09:37:13 -0700
Message-Id: <1420562233-2015-10-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420562233-2015-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

Each coresight block can be part of a power domain.  Using the
generic power domain subsystems to manage power to individual
domains guarantes that coresight operations won't be interrupted
by other components.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 Documentation/devicetree/bindings/arm/coresight.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
index d790f49066f3..27f96f0d36ef 100644
--- a/Documentation/devicetree/bindings/arm/coresight.txt
+++ b/Documentation/devicetree/bindings/arm/coresight.txt
@@ -50,6 +50,10 @@ its hardware characteristcs.
 	* cpu: the cpu phandle this ETM/PTM is affined to. When omitted the
 	  source is considered to belong to CPU0.
 
+	* power-domains: a handle to the generic power domain node this
+	  coresight block is affined to.  When omitted the component is
+	  assumed to always be powered.
+
 * Optional property for TMC:
 
 	* arm,buffer-size: size of contiguous buffer space for TMC ETR
-- 
1.9.1

