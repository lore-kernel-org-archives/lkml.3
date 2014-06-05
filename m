Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaFEPsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:48:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaFEPsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:48:19 -0400
Date: Thu, 5 Jun 2014 08:52:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Rob Clark <robdclark@gmail.com>, Thierry Reding <thierry.reding@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fence: Use smp_mb__before_atomic()
Message-ID: <20140605155200.GC23993@kroah.com>
References: <1401287192-14701-1-git-send-email-thierry.reding@gmail.com>
 <20140528205145.GB10468@kroah.com>
 <20140530081504.GA16669@ulmo>
 <20140530160831.GA11182@kroah.com>
 <CAO_48GE_Y7DQj_nCZ=0gb_AY26_vtPsQybf9zuhsLW1nnaOuQw@mail.gmail.com>
 <20140604132831.GC28484@ulmo>
 <20140604174902.GC20812@kroah.com>
 <CAF6AEGuaURm-AHHh6G=HnJYFLUWBhPOxKaBQCqn-=-9CQdKe8w@mail.gmail.com>
 <53905BD0.9080002@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53905BD0.9080002@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 02:00:16PM +0200, Maarten Lankhorst wrote:
> >I don't think the question about whether we need something like fence
> >to augment dma-buf is really in doubt.  Maybe it should live somewhere
> >else, I'm not sure.  But it makes sense for it to live wherever
> >dma-buf does, as they are intended to work together.
> >
> Additionally we already have a user for this in the kernel: the GPU
> drivers that use TTM.

What about the sync code in the android directory?  I thought that was
supposed to be what GPU drivers were going to use for this type of
thing.

thanks,

greg k-h
