Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3LSCoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:44:22 -0500
Received: from [213.199.154.207] ([213.199.154.207]:53559 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab3LSCoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:44:21 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 19 Dec 2013 10:44:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: mxs: Add iio-hwmon to mx28 soc
Message-ID: <20131219024417.GN6691@S2101-09.ap.freescale.net>
References: <1387392656-28037-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387392656-28037-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 07:50:55PM +0100, Alexandre Belloni wrote:
> This allows to read the SoC on-die temperature sensor available on the LRADC by
> using:
>  cat /sys/class/hwmon/hwmon0/device/temp1_input
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Applied both, thanks.

