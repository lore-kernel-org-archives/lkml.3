Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaBZFH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:07:56 -0500
Received: from [65.55.88.11] ([65.55.88.11]:33137 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751290AbaBZFHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:07:54 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <timur@tabi.org>, <tiwai@suse.de>, <lars@metafoo.de>,
        <Guangyu.Chen@freescale.com>, <fabio.estevam@freescale.com>,
        <shawn.guo@linaro.org>, <denis@eukrea.com>, <mpa@pengutronix.de>,
        <s.hauer@pengutronix.de>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 00/10] Simplify the code of TDM slot setting
Date: Wed, 26 Feb 2014 11:59:25 +0800
Message-ID: <1393387175-15539-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Xiubo Li (10):
  ASoC: core: Add snd_soc_dai_set_tdm_slot_xlate().
  ASoC: fsl-utils: Add fsl_asoc_of_xlate_tdm_slot_mask() support.
  ASoC: fsl-esai: Add .of_xlate_tdm_slot_mask() support.
  ASoC: fsl-ssi: Add .of_xlate_tdm_slot_mask() support.
  ASoC: imx-ssi: Add .of_xlate_tdm_slot_mask() support.
  ASoC: simple-card: Use snd_soc_dai_set_tdm_slot_xlate()
  ASoC: blackfin: bf5xx-ad1836: Use snd_soc_dai_set_tdm_slot_xlate()
  ASoC: blackfin: bf5xx-ad193x: Use snd_soc_dai_set_tdm_slot_xlate()
  ASoC: fsl: eukrea-tlv320: Use snd_soc_dai_set_tdm_slot_xlate()
  ASoC: fsl: wm1133-ev1: Use snd_soc_dai_set_tdm_slot_xlate()

 include/sound/soc-dai.h           |  3 +++
 sound/soc/blackfin/bf5xx-ad1836.c |  2 +-
 sound/soc/blackfin/bf5xx-ad193x.c |  4 ++--
 sound/soc/fsl/Kconfig             |  3 +++
 sound/soc/fsl/eukrea-tlv320.c     |  2 +-
 sound/soc/fsl/fsl_esai.c          |  2 ++
 sound/soc/fsl/fsl_ssi.c           |  2 ++
 sound/soc/fsl/fsl_utils.c         | 27 +++++++++++++++++++++++++++
 sound/soc/fsl/fsl_utils.h         |  4 +++-
 sound/soc/fsl/imx-ssi.c           |  2 ++
 sound/soc/fsl/wm1133-ev1.c        | 11 +----------
 sound/soc/generic/simple-card.c   |  7 +++----
 sound/soc/soc-core.c              | 33 ++++++++++++++++++++++++++++-----
 13 files changed, 78 insertions(+), 24 deletions(-)

-- 
1.8.4


