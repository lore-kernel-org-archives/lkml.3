Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3A2Hvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:51:39 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:31864
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753045Ab3A2Hvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:51:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 29 Jan 2013 15:51:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Brian Lilly <brian@crystalfontz.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: cfa10049: Change the SPI3 bus to spi-gpio
Message-ID: <20130129075146.GE21504@S2101-09.ap.freescale.net>
References: <1359103175-26304-1-git-send-email-maxime.ripard@free-electrons.com>
 <1359103175-26304-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1359103175-26304-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 09:39:35AM +0100, Maxime Ripard wrote:
> The DAC found on the last chip select requires a word length of 12 bits,
> which is not supported by the SSP controller of the iMX28. Use
> bitbanging for that bus to support such a length.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied, thanks.

