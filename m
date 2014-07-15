Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaGORaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:30:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaGORaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:30:52 -0400
Date: Tue, 15 Jul 2014 10:35:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sam Asadi <asadi.samuel@gmail.com>
Cc: devel@driverdev.osuosl.org, Simon Horman <horms+renesas@verge.net.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/94] ARM: shmobile: Add DT and defconfigs to MAINTAINERS
Message-ID: <20140715173525.GA4958@kroah.com>
References: <1405443280-15138-1-git-send-email-asadi.samuel@gmail.com>
 <20140715170530.GA16841@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715170530.GA16841@kroah.com>
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

Ok, what are you doing here?  You just sent 94 patches that are already
committed in the kernel tree.  Why in the name of ${DIETY} would you do
that?

What are you trying to do?

confused,

greg k-h
