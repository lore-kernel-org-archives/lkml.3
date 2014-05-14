Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaENCzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:55:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43813 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaENCze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:55:34 -0400
Message-ID: <5372DB0D.5070206@huawei.com>
Date: Wed, 14 May 2014 10:55:09 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Jiri Olsa <jolsa@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <linux-kernel@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
        <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        <a.p.zijlstra@chello.nl>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Huxinwei <huxinwei@huawei.com>, <peifeiyue@huawei.com>
Subject: Re: Does perf support different length of user-space hw_breakpoint?
References: <53707DD6.2000108@huawei.com> <20140513120046.GB1138@krava.brq.redhat.com> <20140513150613.GC13828@localhost.localdomain>
In-Reply-To: <20140513150613.GC13828@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/5/13 23:06, Frederic Weisbecker 写道:
> On Tue, May 13, 2014 at 02:00:46PM +0200, Jiri Olsa wrote:
>> On Mon, May 12, 2014 at 03:52:54PM +0800, xiakaixu wrote:
>>> Hi guys,
>>>
>>> Does perf support different length of user-space hw_breakpoint,
>>> such as  HW_BREAKPOINT_LEN_1/HW_BREAKPOINT_LEN_2/HW_BREAKPOINT_LEN_4/
>>> HW_BREAKPOINT_LEN_8?
>>>
>>> Seems perf only support HW_BREAKPOINT_LEN_4/sizeof(long)
>>> by default from the source code and simple test.
>>
>> right..
>>
>>         /*
>>          * We should find a nice way to override the access length
>>          * Provide some defaults for now
>>          */
>>         if (attr.bp_type == HW_BREAKPOINT_X)
>>                 attr.bp_len = sizeof(long);
>>         else
>>                 attr.bp_len = HW_BREAKPOINT_LEN_4;
>>
>>>
>>> May I have your opinions if I want to trace different bytes of
>>> hw_breakpoint addr?
>>
>> I guess that depends on what you want to do ;-)
> 
> Ah, I have a patchset from Jacob Shin and Suravee Suthikulpanit that does
> that. Also it has been hanging around for too long by my fault. I'm posting
> it now.

Thanks for your reply!
Hopefully I can get it ASAP.
> .
> 


