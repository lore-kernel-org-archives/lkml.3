Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaDVR7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:59:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42679 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933484AbaDVR7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:59:44 -0400
Date: Tue, 22 Apr 2014 13:59:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, <robh+dt@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] usb: ohci-exynos: Add facility to use phy provided by
 the generic phy framework
In-Reply-To: <CAFp+6iGrgMTE27FxpFTQfALJO_XypxGSZ1-wny8KAoY1sLBbWw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1404221358530.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014, Vivek Gautam wrote:

> On Thu, Apr 10, 2014 at 6:54 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> > Add support to consume phy provided by Generic phy framework.
> > Keeping the support for older usb-phy intact right now, in order
> > to prevent any functionality break in absence of relevant
> > device tree side change for ohci-exynos.
> > Once we move to new phy in the device nodes for ohci, we can
> > remove the support for older phys.
> 
> Any comments on this please.
> I think whatever the approach we follow, that can be common to both
> ehci-exynos[1], and ohci-exynos, since
> both are needed to move to the new generic phy framework, keeping
> support for older usb-phy
> so as to have smooth transition, in order to avoid any regression.

I lost my copies of the ehci-exynos patch, but probably the same 
comments apply as for the ohci-exynos patch.

Alan Stern

