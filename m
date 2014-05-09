Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaEIDeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 23:34:37 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:7932 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEIDeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 23:34:36 -0400
Message-ID: <536C4C90.4060501@huawei.com>
Date: Fri, 9 May 2014 11:33:36 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <xiaofeng_yan2004@126.com>
Subject: Re: [PATCH] sched/rt: Fix a comment in struct sched_dl_entity
References: <1399545080-17823-1-git-send-email-xiaofeng.yan@huawei.com> <20140508110422.GI2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140508110422.GI2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/8 19:04, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 10:31:20AM +0000, xiaofeng.yan wrote:
>> Change sched_setscheduler2() to sched_setscheduler() in the comments.
>> There isn't function sched_setscheduler2() in the main line.
>> The previous EDF version defines this function
>> before being merged into the main line.
>> User should use sched_setscheduler() instead of
>> sched_setscheduler2() now.
> Nah, you fail.. the interface is now called sched_setattr()
>
>
thanks for your reply. I will  push new patch according to your suggest.

Thanks
xiaofeng.yan

