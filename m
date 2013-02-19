Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3BSB47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:56:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:54600 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3BSB46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:56:58 -0500
Message-ID: <5122DBC1.6010507@huawei.com>
Date: Tue, 19 Feb 2013 09:56:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: Re: [PREEMPT RT] SLUB and split softirq lock for v3.2-rt
References: <1360771932-27150-1-git-send-email-bigeasy@linutronix.de> <1360776274.23152.7.camel@gandalf.local.home> <5122DB72.7030100@huawei.com>
In-Reply-To: <5122DB72.7030100@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/19 9:54, Li Zefan wrote:
> On 2013/2/14 1:24, Steven Rostedt wrote:
>> On Wed, 2013-02-13 at 17:11 +0100, Sebastian Andrzej Siewior wrote:
>>> 3.2-rt is a long term supported kernel, which lacks two RT features
>>> from 3.6: SLUB support and the split softirq lock implementation.
>>>
>>> SLUB has a way better performance than SLAB on RT and the split
>>> softirq lock implementation is necessary especially for realtime
>>> networking applications.
>>>
>>> The following patch series backports these features to 3.2-rt.
>>>
>>> Steven, could you please apply these patches to a separate
>>> 3.2-rt-features branch?
>>
>> Is it possible to separate these two features into two different patch
>> sets. I would like to apply the softirq changes first, and then apply
>> the slub changes.
>>
>> Although it looks as though the first half is softirq only 1-8, and the
>> second half is slub related 9-16. If that's the case, I'll just pull in
>> 1-8 first, play with them, and then do 9-16.
>>
> 
> We've also ported these two features to 3.4-rt. Do you want us to post
> them?
> 

Oh ignore me. Just saw the patchset for 3.4-rt.

