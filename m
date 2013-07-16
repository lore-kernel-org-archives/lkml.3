Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3GPBaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 21:30:24 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:36002
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab3GPBaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 21:30:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z551biz98dI9371I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 16 Jul 2013 09:30:04 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Otavio Salvador <otavio@ossystems.com.br>
CC: Fabio Estevam <festevam@gmail.com>, Jonathan Cameron <jic23@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] ARM: dts: imx23-evk: enable USB PHY and controller
Message-ID: <20130716013002.GC28375@S2101-09.ap.freescale.net>
References: <1373898160-8460-1-git-send-email-otavio@ossystems.com.br>
 <CAOMZO5C_7nJ9RVYvuKJHP2u0mYY6P2UyGVA6OpPzqTnd7YXN2Q@mail.gmail.com>
 <CAP9ODKpr82mMoxhiv=K70RKdn01b=ZM2J9E4vV-AM5nwXxUR+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAP9ODKpr82mMoxhiv=K70RKdn01b=ZM2J9E4vV-AM5nwXxUR+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:39:13PM -0300, Otavio Salvador wrote:
> On Mon, Jul 15, 2013 at 12:39 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > Hi Otavio,
> >
> > On Mon, Jul 15, 2013 at 11:22 AM, Otavio Salvador
> > <otavio@ossystems.com.br> wrote:
> >> The i.MX23EVK board provides a USB port so the USB PHY and controller
> >> need to be enabled for it to be usable.
> >>
> >> Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
> >> ---
> >
> > You should have Cc'd Shawn Guo on this series.
> 
> Oh; thanks for fix my mistake. I am new to kernel development :-)

I'm on copy of patches 1, 3 and 4.  2 and 5 are missing?

Shawn

