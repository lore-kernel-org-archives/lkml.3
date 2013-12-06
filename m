Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3LFPi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 10:38:26 -0500
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:37884
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756598Ab3LFPiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 10:38:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] Enhance imx-wm8962 machine driver
Date: Fri, 6 Dec 2013 23:38:27 +0800
Message-ID: <cover.1386344000.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although there's no direct relationship between any of these two patches,
I recommend to apply them in order so as to circumvent merging conflicts.

Changlog:
v2:
 * Nothing changed for PATCH-1.
 * Added spinlock potection for boolean fll_locked in PATCH-2
 * Dropped PATCH-3, will try to revise it next time.

Nicolin Chen (2):
  ASoC: fsl: imx-wm8962: Don't update bias_level in machine driver
  ASoC: fsl: imx-wm8962: Grant hw_params/free() permission to control
    FLL

 sound/soc/fsl/imx-wm8962.c | 152 +++++++++++++++++++++++++++++----------------
 1 file changed, 99 insertions(+), 53 deletions(-)

-- 
1.8.4


