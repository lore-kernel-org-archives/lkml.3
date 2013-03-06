Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab3CFMMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:12:01 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64418 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab3CFML7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:11:59 -0500
Date: Wed, 6 Mar 2013 20:12:21 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, stable <stable@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remoteproc: properly fix missing CONFIG_FW_LOADER
 configurations
Message-ID: <20130306121221.GA12895@kroah.com>
References: <1362511248.16460.113.camel@x61.thuisdomein>
 <20130305215408.GD10965@kroah.com>
 <1362522169.16460.151.camel@x61.thuisdomein>
 <20130306004609.GB28448@kroah.com>
 <1362556402.16460.158.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362556402.16460.158.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 06, 2013 at 08:53:22AM +0100, Paul Bolle wrote:
> On Wed, 2013-03-06 at 08:46 +0800, Greg KH wrote:
> > On Tue, Mar 05, 2013 at 11:22:49PM +0100, Paul Bolle wrote:
> > > 1) But actually thinking about this: that upstream commit did end up in
> > > the (longterm) v3.4.y series. And my patch is also relevant for the
> > > v3.8.y series.
> > 
> > As that patch was in the 3.5-rc7 release, how can it be relevant for
> > 3.8, or anything greater than 3.5 at all?
> 
> I seem to have confused you. My patch fixes a bug caused by a commit
> that shipped in final release v3.5 (and is also part the 3.4.y series,
> because that commit got added to that stable series).

What commit are you talking about here?  Please read
Documentation/stable_kernel_rules.txt for how to have a patch applied to
the stable kernel releases.

Hint, this isn't how you do it...

greg k-h
