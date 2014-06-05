Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372AbaFEPrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:47:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaFEPrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:47:21 -0400
Date: Thu, 5 Jun 2014 08:51:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Clark <robdclark@gmail.com>, Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140605155103.GB23993@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
 <20140530081504.GA16669@ulmo>
 <20140530160831.GA11182@kroah.com>
 <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
 <20140604132831.GC28484@ulmo>
 <20140604174902.GC20812@kroah.com>
 <CAF6AEGuaURm-AHHh6G=HnJYFLUWBhPOxKaBQCqn-=-9CQdKe8w@mail.gmail.com>
 <CAO_48GG0Gm3d7=CkT+z00-f7RSy7snAg4Vkes1c5J6ZXXELWPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_48GG0Gm3d7=CkT+z00-f7RSy7snAg4Vkes1c5J6ZXXELWPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:56:36PM +0530, Sumit Semwal wrote:
> Hi Greg,
> Pending agreement on the need of fence.c (Rob has given the most
> prominent use case for it, and the lack of existing mechanisms to use
> already),

See my disagreement there :)

> would you be ok if I move all the dma-buf* and related (fence.c etc)
> to its own subdirectory and queue it up for this release?

This release (i.e. 3.16) is way too early.  You need to get agreement of
what gets into linux-next first, tested there, and then you can get it
merged into Linus's tree.

In the middle of the merge window is not the time to be moving files
around and disagreeing on if the code is needed or not at all.

So, again, please drop the code from your trees (or whomever trees this
code is in), resend it, notifying everyone involved, and we can take it
from there.

And yes, to be clear, this isn't going to make 3.16, sorry.

thanks,

gre k-h
