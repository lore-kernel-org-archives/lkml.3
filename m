Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaEMGmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:42:08 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:14585 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbaEMGmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:42:05 -0400
X-IronPort-AV: E=Sophos;i="4.97,1041,1389715200"; 
   d="scan'208";a="30439252"
Message-ID: <5371BFA6.3090704@cn.fujitsu.com>
Date: Tue, 13 May 2014 14:45:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 08/10 V2] workqueue: rename manager_mutex to attach_mutex
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-9-git-send-email-laijs@cn.fujitsu.com> <20140512220102.GH18959@mtj.dyndns.org>
In-Reply-To: <20140512220102.GH18959@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 06:01 AM, Tejun Heo wrote:
> On Mon, May 12, 2014 at 02:56:20PM +0800, Lai Jiangshan wrote:
>> manager_mutex is only used to protect the attaching for the pool
>> and the pool->workers list. It protects the pool->workers and operations
>> based on this list, such as:
>> 	cpu-binding for the workers in the pool->workers
>> 	concurrency management for the workers in the pool->workers
> 
> Concurrency management?  What are you referring to?

The operations to set/clear POOL_DISASSOCIATED and WORKER_UNBOUND

Which words will be better if I don't use "Concurrency management"

> 
> thanks.
> 

