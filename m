Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaEVH1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:27:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaEVH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:27:45 -0400
Date: Thu, 22 May 2014 10:27:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Shinya Kuribayashi'" <shinya.kuribayashi.px@renesas.com>,
        "'Magnus Damm'" <damm@opensource.se>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        "'Joe Perches'" <joe@perches.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] clocksource: em_sti: remove unnecessary OOM messages
Message-ID: <20140522072703.GQ17724@mwanda>
References: <002c01cf6384$781c57b0$68550710$%han@samsung.com>
 <002d01cf6384$a6dbcf90$f4936eb0$%han@samsung.com>
 <5379E177.2030707@linaro.org>
 <001a01cf757a$087b4530$1971cf90$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001a01cf757a$087b4530$1971cf90$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 01:55:20PM +0900, Jingoo Han wrote:
> On Monday, May 19, 2014 7:48 PM, Daniel Lezcano wrote:
> > On 04/29/2014 10:26 AM, Jingoo Han wrote:
> > > The site-specific OOM messages are unnecessary, because they
> > > duplicate the MM subsystem generic OOM message.
> > 
> > Are you sure the MM subsys display a message when an allocation fails ?
> > 
> > There are multiple reasons an allocation can fail.
> 
> (+cc Viresh Kumar, Laurent Pinchart, Dan Carpenter, Joe Perches,
>        Thierry Reding, Andrew Morton)
> 
> There was a discussion about this in other threads. [1]
> Please refer to the following link. Thank you.
> 
> [1] http://patchwork.ozlabs.org/patch/324158/
> 

Yes yes.  These are the right things to do, no need to add me to the CC
list, Jingoo.

Someone was going to give a talk on removing these as part of their
kernel smallification project or something...

regards,
dan carpenter

