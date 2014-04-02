Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbaDBKwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 06:52:21 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:57049
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758464AbaDBKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 06:52:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 0/3] regmap: add LE and DT binding for endianness
Date: Wed, 2 Apr 2014 18:09:06 +0800
Message-ID: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For this patch series has dependency, so resend them together.


Change in v2:
- resend 'regmap: implement LE formatting/parsing for 16/32-bit values.'
- resend 'regmap: Add the DT binding documentation for endianness'
- fix the commit message of 'regmap: add DT endianness binding support.'




Xiubo Li (3):
  regmap: implement LE formatting/parsing for 16/32-bit values.
  regmap: Add the DT binding documentation for endianness
  regmap: add DT endianness binding support.

 .../bindings/regmap/regmap-endianness.txt          |  49 +++++++
 drivers/base/regmap/regmap.c                       | 141 +++++++++++++++++++--
 2 files changed, 180 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/regmap/regmap-endianness.txt

-- 
1.8.4


