Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaHTQ5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 12:57:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaHTQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 12:56:39 -0400
Date: Wed, 20 Aug 2014 11:55:59 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: "Chen, Alvin" <alvin.chen@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: pch_udc: USB gadget device support for Intel Quark
 X1000
Message-ID: <20140820165559.GA19000@kroah.com>
References: <1407172974-22485-1-git-send-email-alvin.chen@intel.com>
 <20140820145446.GB24500@saruman.home>
 <20140820161505.GB17908@kroah.com>
 <20140820162008.GK24500@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820162008.GK24500@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:20:09AM -0500, Felipe Balbi wrote:
> On Wed, Aug 20, 2014 at 11:15:05AM -0500, Greg KH wrote:
> > On Wed, Aug 20, 2014 at 09:54:46AM -0500, Felipe Balbi wrote:
> > > Hi Greg,
> > > 
> > > On Mon, Aug 04, 2014 at 10:22:54AM -0700, Chen, Alvin wrote:
> > > > From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > > > 
> > > > This patch is to enable the USB gadget device for Intel Quark X1000
> > > > 
> > > > Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> > > > Signed-off-by: Bing Niu <bing.niu@intel.com>
> > > > Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> > > 
> > > this patch is basically just a new device ID being added to an existing
> > > driver, do you mind if I add it to the -rc or you prefer to wait for
> > > v3.18 merge window ?
> > 
> > New ids are fine for -rc and stable kernels, don't wait for 3.18.
> 
> it does a little more than that as it needs to select the proper PCI
> BAR for Quark, I guess that's still fine ?

Yes, as it's totally safe if you don't have this hardware, so all should
be good.

thanks,

greg k-h
