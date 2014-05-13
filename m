Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbaEMLjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:39:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:48333 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbaEMLjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:39:10 -0400
Message-ID: <53720445.9090506@huawei.com>
Date: Tue, 13 May 2014 19:38:45 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, <fweisbec@gmail.com>
CC: kaixu xia <xiakaixu1987@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Namhyung Kim <namhyung@kernel.org>, Huxinwei <huxinwei@huawei.com>,
        <peifeiyue@huawei.com>
Subject: Re: Does perf support different length of user-space hw_breakpoint?
References: <53707DD6.2000108@huawei.com> <20140512080503.GL30445@twins.programming.kicks-ass.net> <CAGjdHukwC3cu3YOSSteXsC4_52m-YTdAAYCfXV+q5A2pnW+CKQ@mail.gmail.com> <20140512084823.GO30445@twins.programming.kicks-ass.net> <53708DAE.6080903@huawei.com>
In-Reply-To: <53708DAE.6080903@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping....
于 2014/5/12 17:00, xiakaixu 写道:
> 于 2014/5/12 16:48, Peter Zijlstra 写道:
>> On Mon, May 12, 2014 at 04:20:44PM +0800, kaixu xia wrote:
>>> 2014-05-12 16:05 GMT+08:00 Peter Zijlstra <peterz@infradead.org>:
>>>
>>>> On Mon, May 12, 2014 at 03:52:54PM +0800, xiakaixu wrote:
>>>>> Hi guys,
>>>>>
>>>>> Does perf support different length of user-space hw_breakpoint,
>>>>> such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
>>>>> HW_BREAKPOINT_LEN_8?
>>>>>
>>>>> Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
>>>>> by default from the source code and simple test.
>>>>>
>>>>> May I have your opinions if I want to trace different bytes of
>>>>> hw_breakpoint addr?
>>>>
>>>> Frederic?
>>>>
>>>
>>> Sorry, can not fully understand it. Can you give more details on that?
>>
>> I asked Frederic to answer your question :-)
>>
> Thanks:-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


