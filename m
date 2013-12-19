Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3LSPLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:11:22 -0500
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:51157 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752894Ab3LSPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:11:19 -0500
X-Greylist: delayed 2172 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 10:11:19 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 0/3] ARM: at91/dt: add clock properties to sama5d3 crypto devs
Date: Thu, 19 Dec 2013 16:11:12 +0100
Message-Id: <1387465875-4548-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 912541875829504108
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds missing clock properties in sama5d3 crypto devices nodes.

Best Regards,

Boris

Boris BREZILLON (3):
  ARM: at91/dt: add clk properties to sama5d3 SHA device node
  ARM: at91/dt: add clk properties to sama5d3 AES device node
  ARM: at91/dt: add clk properties to sama5d3 TDES device node

 arch/arm/boot/dts/sama5d3.dtsi |    6 ++++++
 1 file changed, 6 insertions(+)

-- 
1.7.9.5

