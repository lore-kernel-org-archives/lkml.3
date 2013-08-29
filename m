Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab3H2XmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 19:42:16 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:53525 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3H2XmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 19:42:15 -0400
Message-ID: <521FDBB6.1030601@huawei.com>
Date: Fri, 30 Aug 2013 07:39:34 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: <akpm@linux-foundation.org>, <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <eparis@redhat.com>, <tglx@linutronix.de>, <rusty@rustcorp.com.au>,
        <ebiederm@xmission.com>, <paulmck@linux.vnet.ibm.com>,
        <john.stultz@linaro.org>, <mingo@redhat.com>, <peterz@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <jovi.zhangwei@huawei.com>,
        <guohanjun@huawei.com>, <zhangdianfang@huawei.com>,
        <wangyijing@huawei.com>
Subject: Re: [PATCH 00/14] Fix bug about invalid wake up problem
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm so sorry, please ignore this patch set!
I have realized that there is no this problem in our kernel.
Preempt_schedule() has set PREEMPT_ACTIVE before calling
__schedule() and __schedule will check it if current state is not
TASK_RUNNING, avoiding this preemption.

Libin

On 2013/8/29 21:57, Libin wrote:
> 1)Problem Description:
> The prototype of invalid wakeup problem is as follows:
> ========================================================================
> ----------------------------
> Consumer Thread
> ----------------------------
> ...




