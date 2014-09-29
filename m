Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaI2GRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:17:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33856 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaI2GRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:17:11 -0400
Date: Sun, 28 Sep 2014 21:51:53 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] usb: host: ehci-exynos: Remove unnecessary
 usb-phy support
Message-ID: <20140929015153.GA27008@kroah.com>
References: <CAFp+6iGXLKhtGaHm=dFDGCpN38G=w6mX0PuatskBhvcL_HA=Bg@mail.gmail.com>
 <1411364719-28064-1-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iE0DGZ722kqFmBSDSzKLJ38=n3yfzx8t8knncjGbuAkyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFp+6iE0DGZ722kqFmBSDSzKLJ38=n3yfzx8t8knncjGbuAkyA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 10:50:22AM +0530, Vivek Gautam wrote:
> Hi Greg,
> 
> 
> On Mon, Sep 22, 2014 at 11:15 AM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> > Now that we have completely moved from older USB-PHY drivers
> > to newer GENERIC-PHY drivers for PHYs available with USB controllers
> > on Exynos series of SoCs, we can remove the support for the same
> > in our host drivers too.
> >
> > We also defer the probe for our host in case we end up getting
> > EPROBE_DEFER error when getting PHYs.
> >
> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> > Acked-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> 
> Did this one got missed for usb-next ?
> I can only see "usb: host: ohci-exynos: Remove unnecessary usb-phy support"
> in the next branch.
> 
> Ignore me if you have already taken care of this, and plan to queue it up.

If it's not in my tree already, please resend as I don't have this in my
queue anymore.

greg k-h
