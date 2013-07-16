Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3GPQm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:42:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60374 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445Ab3GPQlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:41:53 -0400
From: Nishanth Menon <nm@ti.com>
To: Graeme Gregory <gg@slimlogic.co.uk>, Mark Brown <broonie@kernel.org>
CC: J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] regulator: palmas-pmic: doc: update device tree bindings
Date: Tue, 16 Jul 2013 11:41:08 -0500
Message-ID: <1373992870-20725-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130716161939.GR22506@sirena.org.uk>
References: <20130716161939.GR22506@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We seem to have a few missing updates to device tree bindings with the
latest set of changes getting merged in.

Changes since V1:
	Apologies on the spam, looks like I got the wrong mail ID first time around :(
	minor commit message cleanups

V1: http://marc.info/?l=linux-doc&m=137398467901450&w=2

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
