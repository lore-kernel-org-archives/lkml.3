Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3A2NTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:19:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3A2NTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:19:07 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BWAFvWkW1hIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=1I8Z3gPURYIA:10 a=nU2uBtG1AAAA:8 a=nSjSXtn8ZRMKGcRs2eUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359465545.17639.19.camel@gandalf.local.home>
Subject: Re: Re:[PATCH]sched/rt: Do not try to push tasks if pinned task
 switches to RT
From: Steven Rostedt <rostedt@goodmis.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Libo Chen <chenlibo.3@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>, lizefan@huawei.com,
        jovi.zhangwei@huawei.com
Date: Tue, 29 Jan 2013 08:19:05 -0500
In-Reply-To: <446051359450817@web10d.yandex.ru>
References: <446051359450817@web10d.yandex.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 13:13 +0400, Kirill Tkhai wrote:

> > 
> > The task of p->nr_cpus_allowed =1 would`t be added to pushable_tasks list （see the enqueue_task_rt()）and this push_rt_task() need to push other tasks when rt.overloaded.
> 
> If rq has already had 2 or more pushable tasks and we try to add a pinned task then call of push_rt_task will just waste a time.
> 

Correct, I just have some minor comments about the patch.

-- Steve


