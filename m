Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3ARPjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:39:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43631 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751146Ab3ARPjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:39:07 -0500
Date: Fri, 18 Jan 2013 10:39:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautamvivek1987@gmail.com>
cc: balbi@ti.com, Vivek Gautam <gautam.vivek@samsung.com>,
        <jg1.han@samsung.com>, <linux-samsung-soc@vger.kernel.org>,
        <p.paneri@samsung.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kgene.kim@samsung.com>,
        <rob.herring@calxeda.com>, <sylvester.nawrocki@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 3/4] USB: ehci-s5p: Add phy driver support
In-Reply-To: <CAFp+6iEonM8Kp0LztsqaQ0G1+425tK9f06hyUBeQkbvOaHOzeA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1301181038150.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, Vivek Gautam wrote:

> Hi Alan,
> 
> 
> On Fri, Jan 18, 2013 at 6:46 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Fri, Jan 11, 2013 at 08:32:29PM +0530, Vivek Gautam wrote:
> >> Adding the phy driver to ehci-s5p. Keeping the platform data
> >> for continuing the smooth operation for boards which still uses it
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> Acked-by: Jingoo Han <jg1.han@samsung.com>
> >
> > Missing Alan's Acked-by here.
> >
> 
> Any comments on this patch-series ?

Sorry, this patch and the ohci-exynos one slipped through my net.  
Acked-by's have been sent.

Alan Stern

