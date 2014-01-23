Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaAWSAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:00:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56937 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454AbaAWSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:00:07 -0500
Date: Thu, 23 Jan 2014 17:59:30 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vzapolskiy@gmail.com" <vzapolskiy@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
Message-ID: <20140123175930.GJ15586@e106331-lin.cambridge.arm.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
 <52E0EEB8.4080602@samsung.com>
 <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
 <52E155AD.9070802@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E155AD.9070802@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:47:25PM +0000, Sylwester Nawrocki wrote:
> On 23/01/14 18:41, Mark Rutland wrote:
> >>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> >>> > > index 93cddeb..2da5617 100644
> >>> > > --- a/drivers/crypto/s5p-sss.c
> >>> > > +++ b/drivers/crypto/s5p-sss.c
> >>> > > @@ -22,6 +22,7 @@
> >>> > >  #include <linux/scatterlist.h>
> >>> > >  #include <linux/dma-mapping.h>
> >>> > >  #include <linux/io.h>
> >>> > > +#include <linux/of.h>
> >>> > >  #include <linux/crypto.h>
> >>> > >  #include <linux/interrupt.h>
> >>> > >  
> >>> > > @@ -177,6 +178,12 @@ struct s5p_aes_dev {
> >>> > >  
> >>> > >  static struct s5p_aes_dev *s5p_dev;
> >>> > >  
> >>> > > +static const struct of_device_id s5p_sss_dt_match[] = {
> >>> > > +	{ .compatible = "samsung,s5pv210-secss", },
> >> > 
> >> > nit: the first semicolon could be omitted.
> >
> > I assume you mean comma ratehr than semicolon?
> 
> Indeed...and it's actually the second one :-/

Also, I meant "rather" rather than "ratehr". At least we figured it out
in the end. :)

Thanks,
Mark.
