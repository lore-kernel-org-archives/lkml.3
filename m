Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3CDKI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:08:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:27370 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3CDKI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:08:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,778,1355126400"; 
   d="scan'208";a="208500947"
Date: Mon, 4 Mar 2013 11:08:24 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 00/40] Power: AB8500: Internal development push
Message-ID: <20130304100824.GB15384@sortiz-mobl>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
 <20130302233335.GA25293@lizard.sbx05280.losalca.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302233335.GA25293@lizard.sbx05280.losalca.wayport.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Sat, Mar 02, 2013 at 03:33:35PM -0800, Anton Vorontsov wrote:
> Hello Lee,
> 
> On Fri, Feb 15, 2013 at 12:44:30PM +0000, Lee Jones wrote:
> > This is the 3rd and final instalment of the push to synchronise
> > the ABx500 Battery Management series of internal development patches
> > due for Mainline.
> > 
> > This patch-set submission is for reviewing purposes only. Please
> > don't apply patches directly from this patch-set, as there are some
> > interdependencies with another patch-set due for the MFD tree. We
> > can chat about how to over-come this at a later date.
> 
> It looks so much better than the initial series! Frankly, I couldn't find
> anything utterly wrong with it. :-)  (I did notice a couple of cosmetic
> issues, but considering the amount of work and patches needed rebasing, it
> would be insane of me to ask fixing these. :-)
> 
> So, I can easily merge it, as long as MFD part is either Acked or handled
> somehow else. 
I can Ack the MFD parts, they look good to me. And then you can take the whole
thing through your tree, but I'd prefer you to do so by pulling the branch Lee
prepared for us. I want to avoid conflicts this way.

> But I do want to merge the drivers/power/ part via battery
> tree -- the part is quite large and thus prone to conflicts if someone
> asks me to merge a patch that would touch the same lines.
Certainly. I will only take the MFD parts of it through Lee's branch.
Conflicts will be avoided this way.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
