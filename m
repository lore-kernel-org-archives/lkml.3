Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3LEAu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:50:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58680 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab3LEAuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:50:22 -0500
From: Nishanth Menon <nm@ti.com>
To: Rob Herring <rob.herring@calxeda.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] ARM: OMAP2+/dts: standardize SoC naming
Date: Wed, 4 Dec 2013 18:49:35 -0600
Message-ID: <1386204578-6018-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally attempted partially in [1], the missing binding were
reported as part of Rob's report in [2].

So, here is take two of the series, lacking an standard causes issues
that was fixed such as [3]. Ideally, we should never again introduce a
board file without a exact compatible SoC match.

I have stayed a bit away from updating board and SoC dts files yet
to look at the direction we'd like to go here. If we feel things are
good, I would gladly try to clean our mess up.

Nishanth Menon (2):
  Documentation: dt: OMAP: explicitly state SoC compatible strings
  ARM: OMAP2+: board-generic: update SoC compatibility strings

 .../devicetree/bindings/arm/omap/omap.txt          |   53 ++++++++++++++++++++
 arch/arm/mach-omap2/board-generic.c                |    7 +++
 2 files changed, 60 insertions(+)

[1] https://patchwork.kernel.org/patch/2998201/
[2] http://marc.info/?l=linux-arm-kernel&m=138378029113665&w=2
[3] https://patchwork.kernel.org/patch/3279281/

-- 
1.7.9.5

