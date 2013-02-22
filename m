Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab3BVR2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:28:50 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53498 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BVR2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:28:47 -0500
Date: Fri, 22 Feb 2013 09:28:44 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: William Dauchy <william@gandi.net>
Cc: stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ian.campbell@citrix.com, david.vrabel@citrix.com,
        "Christopher S. Aker" <caker@theshore.net>
Subject: Re: xen-netback fixes for stable 35876b5 3e55f8b
Message-ID: <20130222172844.GA15983@kroah.com>
References: <20130222164728.GB27794@gandi.net>
 <20130222170827.GB5126@kroah.com>
 <20130222171754.GD27794@gandi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222171754.GD27794@gandi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 06:17:54PM +0100, William Dauchy wrote:
> On Feb22 09:08, Greg Kroah-Hartman wrote:
> > You mean 3.4 and newer, right?
> > Are you sure that 3.2 and 3.0 aren't also relevant here?
> 
> They are, but didn't test them directly.
> I just applied them without trouble.

What does that mean?  Should they be applied for those kernels or not?

confused,

greg k-h
