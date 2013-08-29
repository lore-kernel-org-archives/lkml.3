Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3H2CDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:03:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3H2CDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:03:35 -0400
Date: Wed, 28 Aug 2013 19:05:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: dm-devel@redhat.com, kernelnewbies@kernelnewbies.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] dm-lc: plan to go to staging
Message-ID: <20130829020555.GA26206@kroah.com>
References: <521EA567.1070801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521EA567.1070801@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 10:35:35AM +0900, Akira Hayakawa wrote:
> Hi,
> 
> I am happy to see that dm-lc is picked up by LWN.
> http://lwn.net/Articles/562938/
> 
> Now I think I should consider the next step forward.
> 
> 
> As Joe Thornber said before, what I have to do next are
> 1. Get some feedback from 3rd party users.
> 2. Reviewed by Mike Snitzer.
> As in
> http://www.redhat.com/archives/dm-devel/2013-July/msg00137.html
> 
> To achieve the first goal,
> I am thinking of going to staging tree
> for dm-lc to be widely available to people in community.
> 
> dm-lc is now managed in Github repo as a kernel module
> however, getting available in the tree means a lot
> to get 3rd party users.
> 
> Does this plan sound nice?
> 
> If so, what is the next step to go to staging?
> I have a patch against 3.11-rc7 in linux-next locally.
> Sending the patch to Greg is the next step?
> And who and what should be included in CC?

That's fine with me.  For staging drivers, I need a TODO file that lists
what needs to be done to the code to get it into a mergable state for
the "real" part of the kernel, and an email address to cc: patches on.
Also, a MAINTAINERS entry is good as that way the
scripts/get_maintainer.pl tool will properly pick up your email address.

You should generate the patch against the linux-next tree, as I have
lots of new staging drivers in there, ready for 3.12, and if you make a
patch against 3.11-rc7, odds are it will not apply properly.

If you have any other questions, please let me know.

thanks,

greg k-h
