Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbaBNCh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:37:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:34180 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbaBNCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:37:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <lars@metafoo.de>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <b47053@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v3 0/3] Add TDM slot info OF parsing supports
Date: Fri, 14 Feb 2014 09:34:33 +0800
Message-ID: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change in v3:
   - Add .of_xlate_tdm_slot_mask().
   - Add snd_soc_of_xlate_tdm_slot_mask().
   - Remove TDM slot masks OF parsing...
   - Split the TDM infomation into two properties.



Xiubo Li (3):
  ASoC: binding: add tdm-slot.txt
  ASoC: core: add TDM slot parsing from DT supports
  ASoC: simple-card: add slot information parsing supports

 .../devicetree/bindings/sound/simple-card.txt      |  5 ++
 .../devicetree/bindings/sound/tdm-slot.txt         | 20 ++++++++
 include/sound/simple_card.h                        |  2 +
 include/sound/soc-dai.h                            |  2 +
 include/sound/soc.h                                |  3 ++
 sound/soc/generic/simple-card.c                    | 18 +++++++
 sound/soc/soc-core.c                               | 59 ++++++++++++++++++++++
 7 files changed, 109 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tdm-slot.txt

-- 
1.8.4


