Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab3CWKm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 06:42:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:44496 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3CWKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 06:42:54 -0400
Message-ID: <514D8711.8020303@huawei.com>
Date: Sat, 23 Mar 2013 18:42:25 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Jovi Zhang <bookjovi@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2] tracing: Expose event tracing infrastructure
References: <514057BF.6040804@huawei.com>  <CACV3sb+DqAsQtvK0d+vNHCyeJYCqWD29AyikRCV6g-rZp3A8nQ@mail.gmail.com> <1363351889.25967.51.camel@gandalf.local.home>
In-Reply-To: <1363351889.25967.51.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/15 20:51, Steven Rostedt wrote:
> On Fri, 2013-03-15 at 20:31 +0800, Jovi Zhang wrote:
> 
>> Hi steven,
>>
>> Would you please give some comments? patch works normally on my box.
> 
> Yeah, I planned on it today ;-)  Actually, I've been a busy beaver
> lately. The last couple of weeks I have:
> 
>   32 files changed, 5239 insertions(+), 1805 deletions(-)
> 
> (Although some of that work started back last August)
> 
> I still have to finish backporting the patches I said I would take from
> you from earlier this week.
> 
> Anyway, a quick scan of the patch looks fine, and I don't see any major
> issues with it. The only problem is that the changes I've made have
> touched this code a bit and your patch won't apply, with my new work.

Steven, I just saw you have sent a pull request to Ingo with a large update on tracing code,
and bring a little conflicts with this "Expose event tracing infrastructure" patch,
like ftrace_event_file introduced in ftrace_raw_event_<call>.

Do I need to resend this patch based on your new work?(and testing) to make you can merge this patch easily.

Thanks.
> 
> I'm just about finished, the final tests I'm doing on my code are
> looking good and I'm hoping to push my final version to linux-next
> today. If you want to have a head start, you can look at the current
> code (no guarantee that it wont rebase), at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
>  trace/tip/perf/core-5
> 
> -- Steve
> 
> 
> 
> 


