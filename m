Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3H2OMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:12:53 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61418 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3H2OMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:12:52 -0400
Date: Thu, 29 Aug 2013 10:12:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, eparis@redhat.com,
        tglx@linutronix.de, rusty@rustcorp.com.au, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 00/14] Fix bug about invalid wake up problem
Message-ID: <20130829141248.GC3985@htj.dyndns.org>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
 <521F55CD.8090207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521F55CD.8090207@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Thu, Aug 29, 2013 at 10:08:13PM +0800, Libin wrote:
...
> static void simulate_preempted(void)
> {
> 	schedule();
> }

Gees... of course, your test code will stall.  Preemption !=
schedule().  Please take a look at PREEMPT_ACTIVE handling in
__schedule().

Thanks.

-- 
tejun
