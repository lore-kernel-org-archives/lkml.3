Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab3DAGR1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:17:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:45437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab3DAGR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:17:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,385,1363158000"; 
   d="scan'208";a="310361857"
Message-ID: <51592662.7020300@intel.com>
Date: Mon, 01 Apr 2013 14:17:06 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v6 0/21] sched: power aware scheduling
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <5159157F.7060605@linux.vnet.ibm.com>
In-Reply-To: <5159157F.7060605@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 01:05 PM, Michael Wang wrote:
> 
> For the performance one, a bit win here and a bit lost there, well,
> since little float is there, I think at least, no regression.
> 
> But the powersaving one suffered some regression in low-end, is that the
> sacrifice we supposed to do for power saving?

Thanks for testing!
Yes, depends on different benchmark, powersaving policy may lose some
performance.


-- 
Thanks Alex
