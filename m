Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaGOX4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:56:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44581 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826AbaGOXz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:55:56 -0400
Date: Wed, 16 Jul 2014 08:55:53 +0900
From: Simon Horman <horms@verge.net.au>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sam Asadi <asadi.samuel@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/94] ARM: shmobile: Add DT and defconfigs to MAINTAINERS
Message-ID: <20140715235553.GI557@verge.net.au>
References: <1405443280-15138-1-git-send-email-asadi.samuel@gmail.com>
 <20140715170530.GA16841@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715170530.GA16841@kroah.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 10:05:30AM -0700, Greg KH wrote:
> On Tue, Jul 15, 2014 at 07:53:07PM +0300, Sam Asadi wrote:
> > From: Simon Horman <horms+renesas@verge.net.au>
> > 
> > There are a number of DT and defconfig files which
> > are maintained as part of shmobile but have not been
> > listed as such in the MAINTAINERS file. This creates
> > confusion from time to time.
> > 
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> > Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
> 
> Really?  We need a "real" name here.
> 
> And why are you passing on Simon's patches, why would I care about this
> patch to the MAINTAINERS file?
> 
> confused,

I'm also a little confused as this same patch is sitting in my tree
and has been queued up for v3.17 by in the arm-soc tree.
