Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3HGQAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:00:31 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30325 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757074Ab3HGQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:00:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19/6k4Pj7rWGfsp/EyiyGty6vfuwofc9+U=
Date: Wed, 7 Aug 2013 12:00:19 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH] ARM: dts: Fix memory node in skeleton64.dtsi
Message-ID: <20130807160019.GF19280@titan.lakedaemon.net>
References: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
 <5201E7CA.4050601@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201E7CA.4050601@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:23:06AM +0200, Gregory CLEMENT wrote:
> On 07/08/2013 03:33, Stepan Moskovchenko wrote:
> > Update the reg property of the memory node in
> > skeleton64.dtsi to reflect the fact that the root node uses
> > address-cells=2 and size-cells=2.
> 
> Good catch
> 
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Since we introduced the file, and I can't think of any other tree that
should take it, so I'll go ahead and take it.

thx,

Jason.

> > Change-Id: Ie9b61166143969e020ceebc51e9a384405d8c0f2
> > Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> > ---
> >  arch/arm/boot/dts/skeleton64.dtsi |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/skeleton64.dtsi b/arch/arm/boot/dts/skeleton64.dtsi
> > index 1599415..b5d7f36 100644
> > --- a/arch/arm/boot/dts/skeleton64.dtsi
> > +++ b/arch/arm/boot/dts/skeleton64.dtsi
> > @@ -9,5 +9,5 @@
> >  	#size-cells = <2>;
> >  	chosen { };
> >  	aliases { };
> > -	memory { device_type = "memory"; reg = <0 0>; };
> > +	memory { device_type = "memory"; reg = <0 0 0 0>; };
> >  };
> > 
> 
> 
> -- 
> Gregory Clement, Free Electrons
> Kernel, drivers, real-time and embedded Linux
> development, consulting, training and support.
> http://free-electrons.com
