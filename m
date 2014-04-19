Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaDSFHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 01:07:47 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:11486
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbaDSFHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 01:07:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh87h2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 19 Apr 2014 13:07:31 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Silvio Fricke <silvio.fricke@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <linux-kernel@vger.kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <spear-devel@list.st.com>
Subject: Re: [PATCH 0/6] mfd/gpio: cleanup of STMPE driver
Message-ID: <20140419050728.GA9816@dragon>
References: <20140417061136.GD11602@dragon>
 <cover.1397741024.git.silvio.fricke@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1397741024.git.silvio.fricke@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 03:28:05PM +0200, Silvio Fricke wrote:
> Hi,
> 
> I have tested this patches with my data-modul imx6q board.
> So the patches get a:
> 
> Tested-by: Silvio Fricke <silvio.fricke@gmail.com>
> 
> 
> Shawn, can you add this patch to your tree if you pull Linus patches?

Yes, I can apply the edmqmx6 patch below, but will only do that after
Linus' series gets accepted.  Ping me if I forget to.

Shawn

> Silvio Fricke (1):
>   ARM: dts: imx6: edmqmx6: add vcc and vio power supplies to stmpe
> 
>  arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> -- 
> 1.9.1
> 

