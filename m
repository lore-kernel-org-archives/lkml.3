Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206Ab3FCOg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:36:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab3FCOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:36:54 -0400
Date: Mon, 3 Jun 2013 07:37:22 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michal Simek <monstr@monstr.eu>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
        Graeme Smecher <gsmecher@threespeedlogic.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] xilinx systemace: Fix device name assignment for
 SystemACE (from "xs`" to "xsa").
Message-ID: <20130603143722.GA7651@kroah.com>
References: <4b5d6615a1338145a461a6d4e1c7d3e42d4f4522.1369312303.git.michal.simek@xilinx.com>
 <51AC9068.7050203@monstr.eu>
 <20130603142242.GB7024@kroah.com>
 <51ACA928.4090601@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ACA928.4090601@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:33:12PM +0200, Michal Simek wrote:
> On 06/03/2013 04:22 PM, Greg Kroah-Hartman wrote:
> > On Mon, Jun 03, 2013 at 02:47:36PM +0200, Michal Simek wrote:
> >> Hi Greg,
> >>
> >> do you want to take these two patches through your tree?
> > 
> > Why would I be sending in drivers/block/* patches?  I don't have a tree
> > for that, do I?
> 
> Ah ok. I took you because you are 3rd based on get_maintainer patch (50% commit signer)
> 
> 
> >> Or should I take them through my microblaze tree?
> > 
> > Please do, or send them to the block maintainer.
> 
> Who is drivers/block maintainer? I can't see anyone in MAINTAINERS file.

Jens is the block/ maintainer, so I imagine he's also the drivers/block/
maintainer as well.  If not, he would know who.

thanks,

greg k-h
