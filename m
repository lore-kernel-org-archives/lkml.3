Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3KZWrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:47:53 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56743 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399Ab3KZWrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:47:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8IAIsjlVJ5LHyk/2dsb2JhbABZgweDMbMRhUyBKRd0giUBAQU6HCMQCAMOCgklDwUlAyETiAC/cBaOZgeDIIETA5gTkhSDPCg
Date: Wed, 27 Nov 2013 09:47:42 +1100
From: Dave Chinner <david@fromorbit.com>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, akpm@linux-foundation.org,
        mhocko@suse.cz, glommer@openvz.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
Message-ID: <20131126224742.GB10988@dastard>
References: <cover.1385377616.git.vdavydov@parallels.com>
 <20131125174135.GE22729@cmpxchg.org>
 <529443E4.7080602@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529443E4.7080602@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:47:00AM +0400, Vladimir Davydov wrote:
> Hi,
> 
> Thank you for the review. I agree with all your comments and I'll
> resend the fixed version soon.
> 
> If anyone still has something to say about the patchset, I'd be glad
> to hear from them.

Please CC me on all the shrinker/list-lru changes being made as I am
the original author of the list-lru code and the shrinker
integration and have more than a passing interest in ensuring
it doesn't get broken or crippled....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
