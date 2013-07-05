Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3GEG3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 02:29:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:63108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab3GEG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:29:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="360811985"
Message-ID: <51D66771.5070403@intel.com>
Date: Fri, 05 Jul 2013 14:28:01 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, hpa@linux.intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        andi.kleen@intel.com, a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>  <alpine.DEB.2.02.1307041300020.11637@ionos.tec.linutronix.de> <1372961512.8728.32.camel@buesod1.americas.hpqcorp.net> <alpine.DEB.2.02.1307042214090.11637@ionos.tec.linutronix.de> <51D61D97.8060904@intel.com> <alpine.DEB.2.02.1307050742020.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307050742020.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 01:58 PM, Thomas Gleixner wrote:
>> > 
>> > Ingo had merged your branch into sched/core. :)
>> > 
>> > commit f9bed7021710a3e45c331f7d7781de914cc1b939
>> > Merge: 7e76057 67dd331
>> > Author: Ingo Molnar <mingo@kernel.org>
>> > Date:   Wed May 29 11:21:59 2013 +0200
>> > 
>> >     Merge branch 'timers/urgent'
> Not really.
> 
> tip$ git branch --contains f9bed70217
> * master
> 
> tip$ git branch --contains 5d33b883ae
> * master
>   timers/core
> 
> So you are testing tip/master not tip/sched/core.

You'r right. I mixed them. sorry.

-- 
Thanks
    Alex
