Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3CFApx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 19:45:53 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:54471 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3CFApv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 19:45:51 -0500
Date: Wed, 6 Mar 2013 08:46:09 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
Message-ID: <20130306004609.GB28448@kroah.com>
References: <1362511248.16460.113.camel@x61.thuisdomein>
 <20130305215408.GD10965@kroah.com>
 <1362522169.16460.151.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362522169.16460.151.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 11:22:49PM +0100, Paul Bolle wrote:
> On Wed, 2013-03-06 at 05:54 +0800, Greg KH wrote:
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> 
> 0) Actually I just copied the addresses included in commit
> e121aefa7d9f10eee5cf26ed47129237a05d940b upstream without really
> thinking.
> 
> 1) But actually thinking about this: that upstream commit did end up in
> the (longterm) v3.4.y series. And my patch is also relevant for the
> v3.8.y series.

As that patch was in the 3.5-rc7 release, how can it be relevant for
3.8, or anything greater than 3.5 at all?

> Can't this patch, that fixes an obviously bogus commit,
> which was important enough for stable, be itself submitted with
> CC:stable?

How can you expect me to apply something that is already in the tree?  :)

thanks,

greg k-h
