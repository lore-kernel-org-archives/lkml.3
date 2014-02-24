Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaBXXqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:46:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBXXqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:46:05 -0500
Date: Mon, 24 Feb 2014 15:47:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: axel.rasmussen1@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8187se: fix checkpatch.pl issues
Message-ID: <20140224234738.GA22241@kroah.com>
References: <3159008.9WafSrHc87@celine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3159008.9WafSrHc87@celine>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:05:31AM -0700, axel.rasmussen1@gmail.com wrote:
> From: Axel Rasmussen <axel.rasmussen1@gmail.com>
> Date: Mon, 17 Feb 2014 23:50:05 -0700
> Subject: [PATCH] staging: rtl8187se: fix checkpatch.pl issues

Please just use 'git send-email' so I don't have to hand-edit the patch
and strip this out :(

> 
> Reformatted many lines which were too long, replaced various printk
> calls with appropriate netdev_* calls, and fixed some spelling errors.

You did multiple things here to this patch, which should be a big hint
that you need to break it up into smaller pieces, each one doing just
one thing.  Please do so, otherwise as it is, this patch is way too big
to review.

thanks,

greg k-h
