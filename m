Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab3GPOYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:24:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab3GPOYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:24:37 -0400
From: Nishanth Menon <nm@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] regulator: palmas-pmic: doc: update device tree bindings
Date: Tue, 16 Jul 2013 09:23:52 -0500
Message-ID: <1373984635-14958-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We seem to have a few missing updates to device tree bindings with the
latest set of changes getting merged in.

Based on v3.11-rc1 tag

Nishanth Menon (2):
  regulator: palmas-pmic: doc: fix typo for sleep-mode
  regulator: palmas-pmic: doc: remove ti,tstep

 .../devicetree/bindings/regulator/palmas-pmic.txt  |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
1.7.9.5

Regards,
Nishanth Menon
