Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbaCFB4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:56:53 -0500
Received: from [216.32.181.185] ([216.32.181.185]:32737 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755556AbaCFB4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:56:52 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 6 Mar 2014 09:55:29 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stefan Agner <stefan@agner.ch>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: vf610: add UART choice for low-level debug
Message-ID: <20140306015525.GB11366@S2101-09.ap.freescale.net>
References: <4031771265d98dad7b0cc15a1e523f026338b432.1394057216.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4031771265d98dad7b0cc15a1e523f026338b432.1394057216.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:07:48PM +0100, Stefan Agner wrote:
> Add choice for low-level debug UART. Similar to i.MX6, there is a
> numeric configuration, valid choices are 0 to 3.
> Note that the kernel assumes that the boot loader initialized clock
> properly.
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Applied, thanks.

