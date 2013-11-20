Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3KTFlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:41:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3KTFk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:40:56 -0500
Date: Tue, 19 Nov 2013 21:41:19 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: Mark Einon <mark.einon@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] staging: et131x: clean up code
Message-ID: <20131120054119.GC367@kroah.com>
References: <62a00a45d2fc38d1881f153f35ba282e85d78a3e.1384518190.git.gamerh2o@gmail.com>
 <CANK3SE36i0+NQdEtuO+FFebDKtrBBM=RjzB4WqSun2o1FK3xpA@mail.gmail.com>
 <CAAb+SYbnL7bNd6+yibrp+bYRKCM+kC_X+kg+KUsZtGj2S0JaaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAb+SYbnL7bNd6+yibrp+bYRKCM+kC_X+kg+KUsZtGj2S0JaaA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 09:53:36AM +0800, ZHAO Gang wrote:
> > I'm a bit confused - these patches apply to the current head of
> > staging-next, but not on top of your previous two patches. I assume that
> > you're aiming to have these changes on top of your last two, so can you
> > please re-spin them to apply cleanly to the head of (staging-next + your
> > previous patches)?
> 
> Hi, please revert the previous two patches if you can. This four
> patches include previous changes, just more descriptive.
> 
> I think previous patches' style may be not so good, and it had
> received no response when I sent this patch set, so I just dropped
> them and redid the work :-)

In the future, you need to tell me to drop the old ones from my queue.
Normally you can do that by replying to them saying to remove them, or
put a "v2" for "version 2" on this series.

Anyway, as Mark told you to redo them a bit, care to do a "v3" series
with his recommended changes (i.e. the TODO file update)?

thanks,

greg k-h
