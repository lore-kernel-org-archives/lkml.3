Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab3H0HhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:37:25 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:56993 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055Ab3H0HhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:37:23 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PATCH v3 0/2] net/cadence/macb: add support for dt phy definition
Date: Tue, 27 Aug 2013 09:36:47 +0200
Message-Id: <1377589007-3684-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 6287588030041258208
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for ethernet phy definition using device
tree.

This may help in moving some at91 boards to dt (some of them define an
interrupt pin).

Tested on samad31ek.

Best Regards,
Boris

Changes since v2:
 - fix wrong address of phy0 dt node

Changes since v1:
 - fix wrong macb_mii_init return code when no PHY device is discovered

Boris BREZILLON (2):
  net/cadence/macb: add support for dt phy definition
  ARM: at91/dt: define phy available on sama5d3 mother board

 arch/arm/boot/dts/sama5d3xmb.dtsi   |    8 ++++++
 drivers/net/ethernet/cadence/macb.c |   48 +++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 10 deletions(-)

-- 
1.7.9.5

