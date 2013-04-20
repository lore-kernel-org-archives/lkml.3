Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3DTHmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:42:11 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:31050 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3DTHmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:42:09 -0400
Message-ID: <5172468F.7070909@huawei.com>
Date: Sat, 20 Apr 2013 15:41:03 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] spare/sysrq: fix inconstistent help message of sysrq
 key
References: <51385730.7020606@huawei.com> <20130307.162724.2043364205781900432.davem@davemloft.net>
In-Reply-To: <20130307.162724.2043364205781900432.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/8 5:27, David Miller wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> Date: Thu, 7 Mar 2013 17:00:32 +0800
> 
>> Currently help message of /proc/sysrq-trigger highlight its
>> upper-case characters, like below:
>>
>>       SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E)
>>       memory-full-oom-kill(F) kill-all-tasks(I) ...
>>
>> this would confuse user trigger sysrq by upper-case character, which is
>> inconsistent with the real lower-case character registed key.
>>
>> This inconsistent help message will also lead more confused when
>> 26 upper-case letters put into use in future.
>>
>> This patch fix spare sysrq key: "global-regs(y)"
>>
>> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> 
David, this patch is already got your ack,
so would you please pick up this patch into your tree for next 3.10?
Thanks.

