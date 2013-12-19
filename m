Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3LSSlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:41:20 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59878 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3LSSlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:41:19 -0500
X-Originating-IP: 173.246.103.110
Date: Thu, 19 Dec 2013 10:41:11 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: base: Add prototype declaration to the
 header file
Message-ID: <20131219184110.GC17741@jtriplet-mobl1>
References: <20131218063953.GA3180@rashika>
 <1387452297-28836-1-git-send-email-rashika.kheria@gmail.com>
 <20131219181357.GA27658@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131219181357.GA27658@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 10:13:57AM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 04:54:57PM +0530, Rashika Kheria wrote:
> > Add prototype declaration of function memory_block_size_bytes() to
> > the header file include/linux/memory.h.
> > 
> > This eliminates the following warning in memory.c:
> > drivers/base/memory.c:87:1: warning: no previous prototype for ‘memory_block_size_bytes’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Please ALWAYS run your patches through checkpatch.pl so a maintainer
> doesn't have to write you an email like this reminding you to do that...
> 
> Josh, come on, you should have caught this as well, fix up your email
> client to flag stuff like this easier...

If you're referring to the trailing whitespace on the line that was
added, I did indeed miss that.  Sorry about that.

I don't see any option in mutt that would make trailing whitespace
visible; if you know of one, I'd love to hear about it.  I do have vim
configured to highlight trailing whitespace, but I normally review
patches in mutt and then hit reply and use vim to provide a Reviewed-by
or line-by-line feedback if needed.  I should get in the habit of
reviewing patches in vim instead; if I had, I'd have caught this.

- Josh Triplett
