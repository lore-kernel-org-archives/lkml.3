Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3KNLHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:07:22 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:8985 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778Ab3KNLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:07:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <timur@tabi.org>, <shawn.guo@linaro.org>, <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <linux@arm.linux.org.uk>,
        <ijc+devicetree@hellion.org.uk>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>
Subject: [PATCH 0/2] Add monaural audio support for fsl_ssi.c
Date: Thu, 14 Nov 2013 19:07:08 +0800
Message-ID: <1384427230-979-1-git-send-email-b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches need to be applied into one single tree because
the second patch depends on the first one. Without it, SSI would playback
constant noise to the right channel when playback monaural audio files on
i.MX6 Series board.

We might also need to apply the iomux change to the other i.MX platforms,
just currently I don't have those boards so I drop their changes for now.

Nicolin Chen (2):
  ARM: dts: imx: specify the value of audmux pinctrl instead of
    0x80000000
  ASoC: fsl_ssi: Add monaural audio support for non-ac97 interface

 arch/arm/boot/dts/imx6qdl.dtsi | 22 +++++++++++-----------
 sound/soc/fsl/fsl_ssi.c        | 22 +++++++++++++++++++---
 2 files changed, 30 insertions(+), 14 deletions(-)

-- 
1.8.4


