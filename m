Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3HUDKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:10:33 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:23632
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab3HUDKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:10:31 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz1454Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <swarren@wwwdotorg.org>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-pwm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH 0/4] Add freescale ftm pwm driver for Vybrid VF610 TOWER
Date: Wed, 21 Aug 2013 11:07:38 +0800
Message-ID: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is the freescale ftm pwm implementation.
There are 8 channels most supported by the ftm pwm,
and there are two pwm modes:
- Center-Aligned PWM (CPWM) mode
- Edge-Aligned PWM (EPWM) mode

This implementation is only compatible with device tree definition.

Please feel free to comment the dt bindinds.

This patch series is based on linux-next and has been tested on Vybrid VF610TWR board using device tree.

Best Regards,
Xiubo Li



