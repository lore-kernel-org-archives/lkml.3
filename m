Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3ITGHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 02:07:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3ITGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 02:07:13 -0400
Date: Thu, 19 Sep 2013 23:07:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, Andrew Morton <akpm@linux-foundation.org>,
        kyungmin.park@samsung.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, stern@rowland.harvard.edu, broonie@kernel.org,
        tomasz.figa@gmail.com, arnd@arndb.de, grant.likely@linaro.org,
        tony@atomide.com, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, balajitk@ti.com, george.cherian@ti.com,
        nsekhar@ti.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v11 0/8] PHY framework
Message-ID: <20130920060749.GB6983@kroah.com>
References: <1377063973-22044-1-git-send-email-kishon@ti.com>
 <521B0E79.6060506@ti.com>
 <20130827192059.GZ3005@radagast>
 <5225FF63.6080608@ti.com>
 <20130903155030.GA21525@kroah.com>
 <5226F5E2.5010409@ti.com>
 <20130917154107.GH15645@radagast>
 <523BDE70.4090407@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523BDE70.4090407@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:04:40AM +0530, Kishon Vijay Abraham I wrote:
> Hi Greg,
> 
> On Tuesday 17 September 2013 09:11 PM, Felipe Balbi wrote:
> > On Wed, Sep 04, 2013 at 02:27:06PM +0530, Kishon Vijay Abraham I wrote:
> >> On Tuesday 03 September 2013 09:20 PM, Greg KH wrote:
> >>> On Tue, Sep 03, 2013 at 08:55:23PM +0530, Kishon Vijay Abraham I wrote:
> >>>> Hi Greg,
> >>>>
> >>>> On Wednesday 28 August 2013 12:50 AM, Felipe Balbi wrote:
> >>>>> Hi,
> >>>>>
> >>>>> On Mon, Aug 26, 2013 at 01:44:49PM +0530, Kishon Vijay Abraham I wrote:
> >>>>>> On Wednesday 21 August 2013 11:16 AM, Kishon Vijay Abraham I wrote:
> >>>>>>> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> >>>>>>> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> >>>>>>> the PHY with or without using phandle.
> >>>>>>>
> >>>>>>> This framework will be of use only to devices that uses external PHY (PHY
> >>>>>>> functionality is not embedded within the controller).
> >>>>>>>
> >>>>>>> The intention of creating this framework is to bring the phy drivers spread
> >>>>>>> all over the Linux kernel to drivers/phy to increase code re-use and to
> >>>>>>> increase code maintainability.
> >>>>>>>
> >>>>>>> Comments to make PHY as bus wasn't done because PHY devices can be part of
> >>>>>>> other bus and making a same device attached to multiple bus leads to bad
> >>>>>>> design.
> >>>>>>>
> >>>>>>> If the PHY driver has to send notification on connect/disconnect, the PHY
> >>>>>>> driver should make use of the extcon framework. Using this susbsystem
> >>>>>>> to use extcon framwork will have to be analysed.
> >>>>>>>
> >>>>>>> You can find this patch series @
> >>>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing
> >>>>>>
> >>>>>> Looks like there are not further comments on this series. Can you take this in
> >>>>>> your misc tree?
> >>>>>
> >>>>> Do you want me to queue these for you ? There are quite a few users for
> >>>>> this framework already and I know of at least 2 others which will show
> >>>>> up for v3.13.
> >>>>
> >>>> Can you queue this patch series? There are quite a few users already for this
> >>>> framework.
> >>>
> >>> It will have to wait for 3.13 as the merge window for new features has
> >>> been closed for a week or so.  Sorry, I'll queue this up after 3.12-rc1
> >>> is out.
> >>
> >> Alright, thanks.
> > 
> > Just a gentle ping on this one...
> 
> Let me know if you want me to rebase this patch series on the latest mainline HEAD.

Yes please.
