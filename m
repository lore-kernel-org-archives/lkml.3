Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbaCNIrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 04:47:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34928 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbaCNIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:46:54 -0400
Message-ID: <5322C1F3.1020108@linaro.org>
Date: Fri, 14 Mar 2014 16:46:43 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [sched/balance] INFO: possible recursive locking detected
References: <20140303142526.GA8517@localhost> <5321618F.3090801@linaro.org> <20140313085341.GC27627@localhost> <5321739B.1000506@linaro.org> <20140314061643.GA28194@localhost> <5322A110.5030405@linaro.org> <20140314064853.GB29349@localhost> <5322B049.1040301@linaro.org> <20140314074009.GA6709@localhost>
In-Reply-To: <20140314074009.GA6709@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 03:40 PM, Fengguang Wu wrote:
> On Fri, Mar 14, 2014 at 03:31:21PM +0800, Alex Shi wrote:
>> On 03/14/2014 02:48 PM, Fengguang Wu wrote:
>>> On Fri, Mar 14, 2014 at 02:26:24PM +0800, Alex Shi wrote:
>>>> On 03/14/2014 02:16 PM, Fengguang Wu wrote:
>>>>> Alex,
>>>>>
>>>>> Here are the test results for branch alexshi/single-balance
>>>>
>>>>
>>>> Thanks a lot! Fengguang.
>>>> Is the nex04 machine 4P*8 core * HT? and are a04/a06 atom box?
>>>
>>> nex04 is Nehalem-EX. a04/06 are Atom servers.
>>>
>>>> Would you like to share the machine info for nhm8, nhm-white and xps2?
>>>
>>> They are all 1S Nehalem PC.
>>
>> thanks for explanation! Are these all the machine launched in testing?
> 
> All the tested cases are
> 
> /lkp/result/lkp-a04/micro/netperf/120s-200%-SCTP_RR
> /lkp/result/lkp-a04/micro/netperf/120s-200%-SCTP_STREAM
> /lkp/result/lkp-a04/micro/netperf/120s-200%-SCTP_STREAM_MANY
> /lkp/result/lkp-a04/micro/netperf/120s-200%-TCP_CRR
> /lkp/result/lkp-a04/micro/netperf/120s-200%-TCP_MAERTS
> /lkp/result/lkp-a04/micro/netperf/120s-200%-TCP_RR
> /lkp/result/lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
> /lkp/result/lkp-a04/micro/netperf/120s-200%-TCP_STREAM
> /lkp/result/lkp-a04/micro/netperf/120s-200%-UDP_RR
> /lkp/result/lkp-a06/micro/qperf/600s
> /lkp/result/lkp-nex04/micro/ebizzy/200%-100-10
> /lkp/result/nhm-white/sysbench/oltp/600s-100%-1000000
> /lkp/result/nhm8/micro/dbench/100%
> /lkp/result/xps2/micro/pigz/100%
> 

Why not add hackbench and bigger machine? :)

> Thanks,
> Fengguang
> 


-- 
Thanks
    Alex
