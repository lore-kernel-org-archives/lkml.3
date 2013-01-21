Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3AUFvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:51:38 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52091 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699Ab3AUFvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:51:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I1447Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 21 Jan 2013 14:20:13 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Walleij <linus.walleij@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
Message-ID: <20130121062011.GC2272@S2100-06.ap.freescale.net>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
 <20130118080211.GA8706@S2101-09.ap.freescale.net>
 <20130119104045.80e588ed651f40d8c567b7d6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130119104045.80e588ed651f40d8c567b7d6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 10:40:45AM +1100, Stephen Rothwell wrote:
> Hi Shawn,
> 
> On Fri, 18 Jan 2013 16:02:13 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
> >
> > My bad, sorry for that.  I just sent a v2 in reply to this message
> > for fixing the error.  I spent some time trying to install a ppc64
> > toolchain for testing, but unfortunately with on luck.  So Stephen,
> > I have to rely on linux-next to give it a test again.  Thanks.
> 
> Cross compilers suitable for building kernels are available at
> http://www.kernel.org/pub/tools/crosstool/ .

Thanks for the link, Stephen.  I installed the compiler and verified
that the v2 fixes the error.

Shawn

