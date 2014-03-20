Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaCTFz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:55:58 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21333
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751705AbaCTFzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:55:40 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h2668h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <shawn.guo@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 0/3] Add DTS node for FTM PWM
Date: Thu, 20 Mar 2014 13:12:02 +0800
Message-ID: <1395292325-8497-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

The FTM PWM driver has been applied by the Maintainer, so here I resend
this patches based upon git://git.linaro.org/people/shawnguo/linux-2.6.git
newest reporsitory.




Xiubo Li (3):
  ARM: dts: vf610: Add Freescale FTM PWM node. ==> resend v10
  ARM: dts: vf610-twr: Add PWM0's pinctrl node ==> new
  ARM: dts: vf610-twr: Enables FTM PWM device. ==> resend v10

 arch/arm/boot/dts/vf610-twr.dts | 17 +++++++++++++++++
 arch/arm/boot/dts/vf610.dtsi    | 13 +++++++++++++
 2 files changed, 30 insertions(+)

-- 
1.8.4


