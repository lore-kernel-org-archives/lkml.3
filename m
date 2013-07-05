Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3GEBYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:24:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:54112 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab3GEBYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,998,1363158000"; 
   d="scan'208";a="360724178"
Message-ID: <51D61FF2.8050302@intel.com>
Date: Fri, 05 Jul 2013 09:22:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu
Subject: Re: [PATCH 1/3] clocksource: clean up clocksource_select
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-2-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041151170.11637@ionos.tec.linutronix.de> <51D54CBD.1010400@intel.com> <alpine.DEB.2.02.1307041224000.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307041224000.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 06:27 PM, Thomas Gleixner wrote:
>> > BTW, why we allow user override a second best clocksource? I mean user
>> > can override the tsc with hpet. because undetected unstable tsc?
> The user can decide to override with clocksource=jiffies if he wants
> for testing purposes. That wont switch into highres ever if done from
> the kernel command line. Now we have a sysfs interface, so we need to
> sanity check the user override against highres.
> 
> The override is quite useful to test hpet, pmtimer on a machine which
> would always select TSC.

Got it. thanks a lot for friendly explanation!

-- 
Thanks
    Alex
