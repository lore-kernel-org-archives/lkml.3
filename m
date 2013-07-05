Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab3GEBjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:39:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:52962 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3GEBjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,998,1363158000"; 
   d="scan'208";a="264272765"
Message-ID: <51D62384.7030003@intel.com>
Date: Fri, 05 Jul 2013 09:38:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>, andi.kleen@intel.com,
        a.p.zijlstra@chello.nl, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] clocksource: Reselect clocksource when watchdog validated
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com> <1372916056-24301-4-git-send-email-alex.shi@intel.com> <alpine.DEB.2.02.1307041227470.11637@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307041419560.11637@ionos.tec.linutronix.de> <alpine.DEB.2.02.1307042239150.11637@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307042239150.11637@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:46 AM, Thomas Gleixner wrote:
> 
> Reported-by: Alex Shi <alex.shi@intel.com>
> Cc: Hans Peter Anvin <hpa@linux.intel.com>
> Cc: Tim Chen <tim.c.chen@linux.intel.com>
> Cc: Andi Kleen <andi.kleen@intel.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Glad to the problem fixed. Thanks!

-- 
Thanks
    Alex
