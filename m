Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058Ab3EFJjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:39:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:34096 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab3EFJjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:39:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,620,1363158000"; 
   d="scan'208";a="333123268"
Message-ID: <51877A5C.5020903@intel.com>
Date: Mon, 06 May 2013 17:39:40 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com> <518724D1.9040006@linux.vnet.ibm.com> <51874229.8050202@intel.com> <518749A9.8000605@linux.vnet.ibm.com>
In-Reply-To: <518749A9.8000605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> But actually I'm wondering whether it is necessary to change
> effective_load()?
> 
> It is only severed for wake-affine and the whole stuff is still in the
> dark, if patch 1~6 already show good results, why don't we leave it there?

It is used for pipe connected process, and your testing showed it is can
not be removed simply. so..
> 

-- 
Thanks
    Alex
