Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaBTBbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:31:07 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:17529 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaBTBbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:31:04 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 20 Feb 2014 09:30:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Anson Huang <b20788@freescale.com>
Subject: Re: linux-next: manual merge of the imx-mxs tree with the arm-soc
 tree
Message-ID: <20140220013051.GK3010@S2101-09.ap.freescale.net>
References: <20140220114242.b3ce4d77b677544d2feebd3e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140220114242.b3ce4d77b677544d2feebd3e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:42:42AM +1100, Stephen Rothwell wrote:
> Hi Shawn,
> 
> Today's linux-next merge of the imx-mxs tree got conflicts in
> arch/arm/mach-imx/Makefile and arch/arm/mach-imx/common.h between commit
> 28a9f3b078c5 ("ARM: imx6: build pm-imx6q.c independently of CONFIG_PM")
> from the arm-soc tree and commits 8dd751932545 ("ARM: imx: add suspend in
> ocram support for i.mx6q") and 79a8eef47d12 ("RM: imx: add suspend in
> ocram support for i.mx6sl") from the imx-mxs tree.
> 
> I fixed it up (I think, see below) and can carry the fix as necessary (no
> action is required).

Thanks, Stephen.  Once "ARM: imx6: build pm-imx6q.c independently of
CONFIG_PM" hits mainline, I will rebase my branch against the latest -rc
to get rid of the conflicts.

Shawn

