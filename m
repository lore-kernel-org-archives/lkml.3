Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3GEBOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:14:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:15793 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3GEBOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:14:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,998,1363158000"; 
   d="scan'208";a="326977990"
Message-ID: <51D61D97.8060904@intel.com>
Date: Fri, 05 Jul 2013 09:12:55 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de> <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net> <alpine.DEB.2.02.1307042214090.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307042214090.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:27 AM, Thomas Gleixner wrote:
>>>> We find some benchmarks drop a lot on tip/sched/core on many Intel boxes,
> And that branch does NOT have that commit included. So how can you see
> a regression on a branch caused by a commit NOT included into that
> branch?
> 
> The offending commit is in tip timers/core and not in tip
> sched/core. What I'm wanted to say is, that we need a proper
> description of problems and not some random association.
> 
> It tricked you to assume, that I'm not able to figure it out myself :)
> 
> See? These things are complex and subtle, so we need precise
> descriptions and not some sloppy semi correct data.
> 
> I'm well aware of the issue and with Peters help I got a reasonable
> explanation for it. A proper fix is about to be sent out.
> 

Ingo had merged your branch into sched/core. :)

commit f9bed7021710a3e45c331f7d7781de914cc1b939
Merge: 7e76057 67dd331
Author: Ingo Molnar <mingo@kernel.org>
Date:   Wed May 29 11:21:59 2013 +0200

    Merge branch 'timers/urgent'

...

commit 7d194f78bde64ec813c1ed8291181bdd61515e78
Merge: 0298bf7 1eaff67
Author: Ingo Molnar <mingo@kernel.org>
Date:   Tue May 28 09:53:41 2013 +0200

    Merge branch 'timers/core'

commit 0298bf70644d7334bec16ae47f3aa58f4f883b59
Merge: cc662fa 2938d27
Author: Ingo Molnar <mingo@kernel.org>
Date:   Tue May 28 09:49:51 2013 +0200

    Merge branch 'timers/urgent'

-- 
Thanks
    Alex
