Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab3F1Lvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:51:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3F1Lvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:51:35 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CXyMsiOUoYoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=R4sMS_rjWVkA:10 a=VwQbUJbxAAAA:8 a=kKMRLMR-Ui14RdXTScEA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372420293.18733.316.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2 v3] tracing/uprobes: Support ftrace_event_file base
 multibuffer
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 07:51:33 -0400
In-Reply-To: <51CD0E5D.3050605@hitachi.com>
References: <51C90ECC.9030303@huawei.com>
	 <20130627121231.GB8362@linux.vnet.ibm.com>
	 <20130627162720.GA18961@redhat.com> <51CD0E5D.3050605@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 13:17 +0900, Masami Hiramatsu wrote:

> BTW, Steven, could you control the traffic of recent tracing works? :)
> There are several works on the ftrace we made, but each of them
> sometimes conflicting. We'd better make a merge plan or a working
> branch on your tracing tree which allows us to work together on it.

After I pull in patches end test it, I push it up to my for-next branch.

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git

-- Steve


