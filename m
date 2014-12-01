Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaLADNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 22:13:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:7351 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbaLADNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 22:13:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,489,1413270000"; 
   d="scan'208";a="616388603"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH urgent v2] sched: Add missing rcu protection to
 wake_up_all_idle_cpus
Thread-Topic: [PATCH urgent v2] sched: Add missing rcu protection to
 wake_up_all_idle_cpus
Thread-Index: AQHQC++NLFlfGioHH0uJToFDDseD15x6ETtA
Date: Mon, 1 Dec 2014 03:13:26 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01EE72A9@SHSMSX101.ccr.corp.intel.com>
References: <729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net>
In-Reply-To: <729365dddca178506dfd0a9451006344cd6808bc.1417277372.git.luto@amacapital.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@amacapital.net]
> Sent: Sunday, November 30, 2014 12:14 AM
> To: Ingo Molnar; Thomas Gleixner; linux-kernel@vger.kernel.org
> Cc: Peter Zijlstra; Andy Lutomirski; Liu, Chuansheng
> Subject: [PATCH urgent v2] sched: Add missing rcu protection to
> wake_up_all_idle_cpus
> 
> Locklessly doing is_idle_task(rq->curr) is only okay because of RCU
> protection.  The older variant of the broken code checked
> rq->curr == rq->idle instead and therefore didn't need RCU.
> 
> Fixes: f6be8af1c95d sched: Add new API wake_up_if_idle() to wake up the idle
> cpu
> Cc: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
Reviewed-by: Chuansheng Liu <chuansheng.liu@intel.com>

Thanks Andy.

