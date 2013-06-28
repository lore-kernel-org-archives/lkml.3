Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3F1MOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:14:49 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56532 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3F1MOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:14:41 -0400
Message-ID: <51CD7E2E.5030205@hitachi.com>
Date: Fri, 28 Jun 2013 21:14:38 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file
 base multibuffer
References: <51C90ECC.9030303@huawei.com>  <20130627121231.GB8362@linux.vnet.ibm.com>  <20130627162720.GA18961@redhat.com> <51CD0E5D.3050605@hitachi.com> <1372420293.18733.316.camel@gandalf.local.home>
In-Reply-To: <1372420293.18733.316.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/28 20:51), Steven Rostedt wrote:
> On Fri, 2013-06-28 at 13:17 +0900, Masami Hiramatsu wrote:
> 
>> BTW, Steven, could you control the traffic of recent tracing works? :)
>> There are several works on the ftrace we made, but each of them
>> sometimes conflicting. We'd better make a merge plan or a working
>> branch on your tracing tree which allows us to work together on it.
> 
> After I pull in patches end test it, I push it up to my for-next branch.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> 
> -- Steve

Thanks!
So, I'll make a fix on the branch. :)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


