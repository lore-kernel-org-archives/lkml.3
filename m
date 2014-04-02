Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbaDBKJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:09:23 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:31761
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758163AbaDBKJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:09:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz154dIzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alsa-devel@alsa-project.org>, <timur@tabi.org>,
        <Li.Xiubo@freescale.com>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 0/2] ASoC: fsl_sai: Add bus clock and mclks with clock controls
Date: Wed, 2 Apr 2014 18:10:18 +0800
Message-ID: <cover.1396432924.git.Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add clock controls to fsl_sai driver and updates
the vf610.dtsi accordingly.

Changelog
v2:
 * Appended two extra mclks to the driver since SAI actually has three.
 * Renamed clock name to 'bus' and 'mclk' according to the reference manual.

Nicolin Chen (2):
  ASoC: fsl_sai: Add clock controls for SAI
  ARM: dts: Append clock bindings for sai2 on VF610 platform

 .../devicetree/bindings/sound/fsl-sai.txt          |  8 ++--
 arch/arm/boot/dts/vf610.dtsi                       |  6 ++-
 sound/soc/fsl/fsl_sai.c                            | 50 ++++++++++++++++++++--
 sound/soc/fsl/fsl_sai.h                            |  4 ++
 4 files changed, 59 insertions(+), 9 deletions(-)

-- 
1.8.4


