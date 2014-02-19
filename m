Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaBSJn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:43:29 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:13663 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809AbaBSJn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:43:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <linux-pwm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv9 Resend 0/4] Add Freescale FTM PWM driver
Date: Wed, 19 Feb 2014 16:38:53 +0800
Message-ID: <1392799137-17188-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend this patch series, just adding the missing and new Reviewed-by and
Acked-by infomation of this patch series.


Xiubo Li (4):
  pwm: Add Freescale FTM PWM driver support
  ARM: dts: vf610: Add Freescale FTM PWM node.
  ARM: dts: vf610-twr: Enables FTM PWM device.
  Documentation: Add device tree bindings for Freescale FTM PWM.

 .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        |  34 ++
 arch/arm/boot/dts/vf610-twr.dts                    |   6 +
 arch/arm/boot/dts/vf610.dtsi                       |  13 +
 drivers/pwm/Kconfig                                |  10 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-fsl-ftm.c                          | 479 +++++++++++++++++++++
 6 files changed, 543 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
 create mode 100644 drivers/pwm/pwm-fsl-ftm.c

-- 
1.8.4


