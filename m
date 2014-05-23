Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaEWWTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:19:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbaEWWTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:19:42 -0400
Date: Sat, 24 May 2014 07:19:40 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 0/8] Add Allwinner A31 USB support
Message-ID: <20140523221940.GB18106@kroah.com>
References: <20140514160520.GA4679@kroah.com>
 <20140523183339.GC10768@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523183339.GC10768@lukather>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 08:33:39PM +0200, Maxime Ripard wrote:
> Hi Greg,
> 
> On Wed, May 14, 2014 at 06:05:20PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 14, 2014 at 02:34:19PM +0200, Maxime Ripard wrote:
> > > On Tue, May 13, 2014 at 05:44:14PM +0200, Maxime Ripard wrote:
> > > > Hi everyone,
> > > > 
> > > > This patchset adds support for the USB controllers found in the
> > > > Allwinner A31.
> > > > 
> > > > While the design is similar to the earlier Allwinner SoCs that are
> > > > already supported, a few details here and there change, like the fact
> > > > that the PHYs now have one clock per phy, while it used to be only one
> > > > for all the PHYs.
> > > > 
> > > > Resent adding Alan Stern's Acked-by and puting Greg KH in the
> > > > recipients this time...
> > > 
> > > Applied patches 2, 7 and 8.
> > 
> > Feel free to apply patches 5 and 6 to your tree, as your branch needs
> > these, with my:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Or, if you want me to take them, just let me know and I will.
> 
> It looks like it's still not in your tree (or at least, I haven't
> received the usual mail notifications).
> 
> Is this expected?

Given that I haven't applied any USB patches in a week or so, yes, it is
expected...

Give me a week or so to catch up, I've been on the road for a month
now, and am finally home.

greg k-h
