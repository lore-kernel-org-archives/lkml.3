Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaAWRre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:47:34 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15673 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaAWRrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:47:31 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-9b-52e155af5a8b
Message-id: <52E155AD.9070802@samsung.com>
Date: Thu, 23 Jan 2014 18:47:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
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
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
 <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
 <52E0EEB8.4080602@samsung.com>
 <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
In-reply-to: <20140123174121.GI15586@e106331-lin.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/xa7rrQx8GGeybL2Fx9/lhRouXhzQt
	5pxvYbGYf+Qcq0X3KxmL+/d+Mllc3jWHzWLG+X1MFkuvX2SyWLTtP7PFql1/GC3OzjnE5MDj
	sWbeGkaPLStvMnnsnHWX3WPbAVWPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyli0awpTwUT2
	ik8721gbGG+ydjFyckgImEjs7VjHDmGLSVy4t56ti5GLQ0hgKaPEmsbzLCAJIYFPjBJnjrCB
	2LwCWhIzHzwDi7MIqEp8nbYEbBCbgKFE79E+RhBbVCBC4u+89YwQ9YISPybfA6sXEVCX6Nn1
	hQVkAbPAAxaJf38ugyWEBZwl7szoY4JYdptR4ssUYRCbEyh+4ewMsDizgI7E/tZpbBC2vMTm
	NW+ZJzAKzEKyYxaSsllIyhYwMq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECImOrzsYlx6z
	OsQowMGoxMP7IfhhkBBrYllxZe4hRgkOZiURXkczoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG
	XfMvtnfOdA+fu0Ao6MbkVf4CLN+fnfR39bm2yLzPm+vZSf49mvsF/nlVZUYIpm28Pt3WsyHS
	/GTRzbvvtON2VX2v4BZy21ypGH/yzPbOyu2qa/jntV9omah5544Lx4+C7k+bLy6xDXlrWNWn
	XtLyKNl6679b/9KfrVG42Dm38dZ8xqN29WttlFiKMxINtZiLihMB7HDgG2wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 18:41, Mark Rutland wrote:
>>> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
>>> > > index 93cddeb..2da5617 100644
>>> > > --- a/drivers/crypto/s5p-sss.c
>>> > > +++ b/drivers/crypto/s5p-sss.c
>>> > > @@ -22,6 +22,7 @@
>>> > >  #include <linux/scatterlist.h>
>>> > >  #include <linux/dma-mapping.h>
>>> > >  #include <linux/io.h>
>>> > > +#include <linux/of.h>
>>> > >  #include <linux/crypto.h>
>>> > >  #include <linux/interrupt.h>
>>> > >  
>>> > > @@ -177,6 +178,12 @@ struct s5p_aes_dev {
>>> > >  
>>> > >  static struct s5p_aes_dev *s5p_dev;
>>> > >  
>>> > > +static const struct of_device_id s5p_sss_dt_match[] = {
>>> > > +	{ .compatible = "samsung,s5pv210-secss", },
>> > 
>> > nit: the first semicolon could be omitted.
>
> I assume you mean comma ratehr than semicolon?

Indeed...and it's actually the second one :-/

--
Regards,
Sylwester
