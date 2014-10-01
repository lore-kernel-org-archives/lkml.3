Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaJAR6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:58:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaJAR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:58:00 -0400
Date: Wed, 1 Oct 2014 10:57:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Chris Kohn <ckohn@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>, Jason Wu <huanyu@xilinx.com>
Subject: Re: [PATCH] staging: Add Xilinx Clocking Wizard driver
Message-ID: <20141001175704.GA9625@kroah.com>
References: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
 <20141001173957.GA32021@kroah.com>
 <e6907682-8d66-4df0-9a9e-a1079933e358@BL2FFO11FD008.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6907682-8d66-4df0-9a9e-a1079933e358@BL2FFO11FD008.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:46:16AM -0700, Sören Brinkmann wrote:
> On Wed, 2014-10-01 at 10:39AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 01, 2014 at 10:21:48AM -0700, Soren Brinkmann wrote:
> > > Add a driver for the Xilinx Clocking Wizard soft IP. The clocking wizard
> > > provides an AXI interface to dynamically reconfigure the clocking
> > > resources of Xilinx FPGAs.
> > 
> > Why not just do the few things you have on the TODO list and get it
> > merged to the "proper" part of the kernel, keeping it out of the staging
> > tree?
> 
> The few things are not that easy and as I mention in the TODO file,
> there are some patches on LKML that would greatly simplify this
> driver/reduce the need for code duplication.
> I thought this is a good way to wait for those parts to mature while
> people could already use the driver as passive part in their clock tree.

Ok, fair enough, as long as you keep working on the driver to get it out
of staging, I don't have an objection to it.  I'll go queue it up later
today.

greg k-h
