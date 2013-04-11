Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936205Ab3DKDcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:32:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:40052 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3DKDcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:32:13 -0400
Message-ID: <51662E9E.9050400@huawei.com>
Date: Thu, 11 Apr 2013 11:31:42 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/12] event tracing expose change and bugfix/cleanup
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com> <1365606496.9609.13.camel@gandalf.local.home>
In-Reply-To: <1365606496.9609.13.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/10 23:08, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
>> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
>>
>> Hi steven,
>>
>> I have reworked this patchset again with minor change.
>> [v2 -> v3:
>> -   change trace_descripte_t defintion in patch 3
>> -   new patch "export ftrace_events"
>> -   remove patch "export syscall metadata"
>>     (syscall tracing are use same event_trace_ops backend as normal event tracepoint,
>>      so there's no need to export anything of syscall)
>> -   remove private data field in ftrace_event_file struct (also not needed)
>> ]
> 
> Thanks,
> 
> Note, I'm trying to catch up on my -rt responsibilities, and most likely
> wont get to this this week, and next week I'll be at collaboration
> summit. It may not be till after I get back from that, that I'll have a
> chance to look at these.
> 
> Depending on when Linus opens the next merge window, even if everything
> goes fine, this patch set may not make it into 3.10, and will have to
> wait till 3.11.
> 
> Just giving you a heads up.
It's fine for me, let's check this patch set later.
Thanks.
> 
> 
> 
> 


