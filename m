Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaDQGMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:12:03 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:14738
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753128AbaDQGMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:12:01 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz8275dh1de097hz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 17 Apr 2014 14:11:38 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <spear-devel@list.st.com>
Subject: Re: [PATCH 0/6] mfd/gpio: cleanup of STMPE driver
Message-ID: <20140417061136.GD11602@dragon>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 04:44:09PM +0200, Linus Walleij wrote:
> This cleans up the STMPE driver a bit:
> 
> - Remove all static GPIO and IRQ number assignments as all platforms
>   with this hardware use device tree now.
> - Add optional regulators.
> - Add proper device tree probe path using compatible strings.
> - Block mask fix for STMPE1601.
> - Switch GPIO portions to use the gpiolib irqchip helpers.
> 
> This branch is available here if you want to test it:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git stmpe
> 
> It'd be great if someone with the i.MX 53 or 6q platforms using
> this could test it, the same goes for the SPEAr people.

None of my i.MX board on hands uses stmpe, so we may need the favor from
pengutronix folks to test it on imx6q-dmo-edmqmx6 board.

Shawn

