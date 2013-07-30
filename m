Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab3G3DFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 23:05:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52105 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3G3DFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 23:05:13 -0400
Message-ID: <51F72D55.7050108@huawei.com>
Date: Tue, 30 Jul 2013 11:04:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Checkpatch error on trace events macros
References: <20130729195201.GC14883@xanatos> <51F7171C.4060100@huawei.com>  <1375149538.2075.95.camel@joe-AO722> <51F71FBC.6030600@huawei.com> <1375151796.2075.97.camel@joe-AO722>
In-Reply-To: <1375151796.2075.97.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/30 10:36, Joe Perches wrote:
> On Tue, 2013-07-30 at 10:06 +0800, Li Zefan wrote:
>> On 2013/7/30 9:58, Joe Perches wrote:
>>> So what are these TRACE_<FOO> defines that need
>>> excluding from the "complex values" check?
>>>
>>> Anything other than 
>>>
>>> TRACE_SYSTEM
>>> TRACE_INCLUDE_FILE
>>> TRACE_INCLUDE_PATH
>>>
>>> ?
>>>
>>> samples/trace_events/trace-events-sample.h
>>> only has those 3.
>>>
>>
>> Try:
>>   # scripts/checkpatch.pl --file include/trace/events/*
>>
>> You'll see numerous errors. :)
> 
> Nope, you'll see numerous whitespace defects, but no
> actual errors.
> 
> If you run with:
> 
> --ignore=spacing,long_line,code_indent,leading_space,printf_l,split_string,space_before_tab,trailing_whitespace,line_continuations
> 

Serious? I'd just not run checkpatch.pl. ;)

> it's flawless.
> 

The "complex values" check complaints come from many places in include/trace/events/*,
and I'm not going to check where and why.

