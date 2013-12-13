Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3LMPpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:45:09 -0500
Received: from [213.199.154.184] ([213.199.154.184]:22464 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753015Ab3LMPpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:45:06 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>
Subject: [PATCH 0/2] Add missing audio-related clocks to imx6 clock tree
Date: Fri, 13 Dec 2013 23:44:06 +0800
Message-ID: <cover.1386949189.git.Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches appends some essential clocks of audio IP to the
current i.MX6 Series clock trees. 

Nicolin Chen (2):
  ARM: imx6sl: Add missing pll4_audio_div to the clock tree
  ARM: imx6sl: Add missing spba clock to clock tree

 arch/arm/mach-imx/clk-imx6sl.c           | 6 ++++--
 include/dt-bindings/clock/imx6sl-clock.h | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
1.8.4


