Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaIVEpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:45:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:23541 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaIVEpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:45:49 -0400
Message-ID: <541FA943.5070009@huawei.com>
Date: Mon, 22 Sep 2014 12:44:51 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [PATCH 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
References: <541F9C96.10705@huawei.com> <20140922040214.GE23583@htj.dyndns.org>
In-Reply-To: <20140922040214.GE23583@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/22 12:02, Tejun Heo wrote:
> On Mon, Sep 22, 2014 at 11:50:46AM +0800, Zefan Li wrote:
>> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>
>> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
>> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
>> because it is used as bit number. Redefine it as decimal bit number.
> 
> It's also changing the bit position, which is fine but should be
> mentioned in the description.
> 

I've resent the patch with changelog updated.

