Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbaCDJcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:32:08 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:1322 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756462AbaCDJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:32:05 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2izz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [RFC][PATCH 0/3] Remove set_cache_io entirely from ASoC probe
Date: Tue, 4 Mar 2014 16:25:26 +0800
Message-ID: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Xiubo Li (3):
  ASoC: core: Move the default regmap I/O setting to
    snd_soc_register_codec()
  ASoc: codec: remove the set_cache_io() entirely from CODEC ASoC probe.
  ASoC: core: remove the default regmap I/O setting up from
    soc_probe_codec()

 include/sound/soc.h        |  3 +++
 sound/soc/codecs/cq93vc.c  |  6 ++++--
 sound/soc/codecs/mc13783.c | 10 ++--------
 sound/soc/codecs/wm5102.c  |  6 ++----
 sound/soc/codecs/wm5110.c  |  6 ++----
 sound/soc/codecs/wm8350.c  |  6 ++++--
 sound/soc/codecs/wm8400.c  |  6 ++++--
 sound/soc/codecs/wm8994.c  |  4 ++--
 sound/soc/codecs/wm8997.c  |  7 ++-----
 sound/soc/soc-core.c       | 21 +++++++++++----------
 10 files changed, 36 insertions(+), 39 deletions(-)

-- 
1.8.4


