Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab3LQDPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 22:15:15 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:8980
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab3LQDPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 22:15:13 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hz8dhz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 17 Dec 2013 11:16:01 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Chris Ball <cjb@laptop.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-ID: <20131217031600.GG6691@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
 <20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
 <CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Please drop fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support") from
your tree.  It should go via my tree (with a rebase).  Sorry, I did not
notice it early.

Shawn

On Tue, Dec 17, 2013 at 11:07:19AM +0800, Dong Aisheng wrote:
> Hi Stephen,
> 
> Sorry, i just see this mail.
> It seems the imx pinctrl dt binding has changes since Chris pick my patch.
> I will fix it ASAP.
> 
> Regards
> Dong Aisheng
> 
> On Tue, Dec 17, 2013 at 10:28 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Chris,
> >
> > ping?
> >
> > On Fri, 13 Dec 2013 12:57:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >>
> >> After merging the mmc tree, today's linux-next build (arm
> >> multi_v7_defconfig) failed like this:
> >>
> >> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
> >>
> >> ERROR: Input tree has errors, aborting (use -f to force output)
> >> make[2]: *** [arch/arm/boot/dts/imx6dl-sabresd.dtb] Error 2
> >> ERROR (phandle_references): Reference to non-existent node or label "pinctrl_usdhc4_1"
> >>
> >> ERROR: Input tree has errors, aborting (use -f to force output)
> >> make[2]: *** [arch/arm/boot/dts/imx6q-sabresd.dtb] Error 2
> >>
> >> Caused by commit fc4fafac9656 ("ARM: dts: sabresd: add usdhc4 support").
> >>
> >> I have used the mmc tree from next-20131212 for today.
> >
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au

