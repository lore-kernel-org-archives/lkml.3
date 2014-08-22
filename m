Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbaHVH21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 03:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaHVH2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 03:28:25 -0400
Message-ID: <53F6F0E4.4070800@redhat.com>
Date: Fri, 22 Aug 2014 15:27:32 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH net-next 1/2] sched: introduce nr_running_this_cpu()
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <20140821135203.GA29591@gmail.com>
In-Reply-To: <20140821135203.GA29591@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 09:52 PM, Ingo Molnar wrote:
> * Jason Wang <jasowang@redhat.com> wrote:
>
>> This patch introduces a helper nr_running_this_cpu() to return the
>> number of runnable processes in current cpu.
>>
>> The first user will be net rx busy polling. It will use this to exit
>> the busy loop when it finds more than one processes is runnable in
>> current cpu. This can give us better performance of busy polling under
>> heavy load.
> s/one processes/one process
>
> More importantly, please Cc: scheduler maintainers and lkml to 
> both patches, so that the whole intent of the change can be 
> reviewed, in full context.
>
> Thanks,
>
> 	Ingo

Will do this.

Thanks
