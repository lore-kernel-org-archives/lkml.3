Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaABKxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 05:53:21 -0500
Received: from [207.46.163.26] ([207.46.163.26]:33925 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751109AbaABKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 05:53:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <thierry.reding@gmail.com>, <shawn.guo@linaro.org>,
        <linux-pwm@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [PATCHv8 0/4] Add Freescale FTM PWM driver.
Date: Thu, 2 Jan 2014 17:57:00 +0800
Message-ID: <1388656624-26570-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the Freescale FTM PWM implementation. And there
are 8 channels most supported by the FTM PWM. This implementation is
only compatible with device tree definition.

This patch series is based on linux-next and has been tested on Vybrid
VF610 Tower board using device tree.



Changes in v8:
- Fix some issues pointed by Thierry.
- Fix the _readl/_writel of sparse check.

- And the ftm_readl()/ftm_writel() are just copied from the
  readl()/writel(), and then add the big endian check.



Changes in v7:
- Add big-endian mode support.
- Add FTM mutex lock.
- Add period time check with the current running pwm(s).
- Recode the counter clock source selecting.
- Sort some header files alphabetically, etc.

[snip] v1~v6







