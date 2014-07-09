Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaGICII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:08:08 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34339 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaGICIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:08:06 -0400
Message-ID: <53BCA3F9.3030304@huawei.com>
Date: Wed, 9 Jul 2014 10:07:53 +0800
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <mingo@redhat.com>, <juri.lelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <xiaofeng.yan2012@gmail.com>
Subject: Re: [PATCH] sched/deadline: overrun could happen in start_hrtick_dl
References: <1404809607-26197-1-git-send-email-xiaofeng.yan@huawei.com> <20140708093334.GD6758@twins.programming.kicks-ass.net> <53BBD4A7.5050701@huawei.com> <53BBDAFE.1070309@huawei.com> <20140708125203.GP19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140708125203.GP19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.133]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/8 20:52, Peter Zijlstra wrote:
> On Tue, Jul 08, 2014 at 07:50:22PM +0800, xiaofeng.yan wrote:
>> I have tested this solution, It can work very well with deadline schedule
>> class.
> Great, please send it as a proper patch and I might just press 'A' ;-)

Ok, I will send it later.


