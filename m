Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab3BVRId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:08:33 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:59028 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab3BVRIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:08:30 -0500
Date: Fri, 22 Feb 2013 09:08:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: William Dauchy <william@gandi.net>
Cc: stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ian.campbell@citrix.com, david.vrabel@citrix.com,
        "Christopher S. Aker" <caker@theshore.net>
Subject: Re: xen-netback fixes for stable 35876b5 3e55f8b
Message-ID: <20130222170827.GB5126@kroah.com>
References: <20130222164728.GB27794@gandi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130222164728.GB27794@gandi.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 05:47:28PM +0100, William Dauchy wrote:
> Hello,
> 
> I believe the two commits 35876b5 and 3e55f8b could be included in stable tree.
> 35876b5 is related to 4885628 already in the stable tree and fixes a
> possible oops.
> 3e55f8b is fixing another possible oops (see commit messages).
> 
> I tested them on top of a v3.4.33.
> Could we consider adding these patches in stable tree at least for v3.4?

You mean 3.4 and newer, right?

Are you sure that 3.2 and 3.0 aren't also relevant here?

thanks,

greg k-h
