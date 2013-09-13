Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab3IMGC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:02:59 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:56141
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753385Ab3IMGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:02:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <r65073@freescale.com>, <thierry.reding@gmail.com>
CC: <s.hauer@pengutronix.de>, <swarren@wwwdotorg.org>, <t.figa@samsung.com>,
        <grant.likely@linaro.org>, <linux@arm.linux.org.uk>, <rob@landley.net>,
        <ian.campbell@citrix.com>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pwm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCHv4 0/4] Add Freescale FTM PWM driver.
Date: Fri, 13 Sep 2013 13:58:38 +0800
Message-ID: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series is the Freescale FTM PWM implementation. And there are 8 channels most supported by the FTM PWM. This implementation is only compatible with device tree definition.

This patch series is based on linux-next and has been tested on Vybrid VF610 Tower board using device tree.

Changes in v4:
- Check for the result and return an error for devm_kzalloc().
- Move pinmux setting from the SoC file to the board specific file.
- Revise the written mistake of 'ret |= FTMSC_CLKEXT;' --> 'reg |= FTMSC_CLKEXT;'.


Changes in v3:
- Remove "availabe" field.
- Remove "fsl,pwm-avaliable-chs" property.
- ...

Changes in v2:
- Remove PWM CPWM/EPWM feature and sysfs.
- Remove some redundant code.
- Revise some code for more readable.
- Remove "fsl,pwm-clk-ps", "fsl,pwm-number", "fsl,pwm-channels",etc.
- Add "fsl,pwm-avaliable-chs", "fsl,pwm-counter-clk", etc.
- Support 8 channels default in dtsi file.
- Add counter clock source selection.
- Rename some function name, macro name, etc.
- Use PWM's and OF's existing function interfaces.
- Split clk_unprepare_enable to clk_unprepare and clk_enable,etc.
- ...

Added in v1:
- Add Freescale FTM PWM driver support.
- Add Freescale FTM PWM node for VF610.
- Enable Enables FTM PWM device for Vybrid VF610 TOWER.
- Add device tree bindings for Freescale.





