Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3HLAUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 20:20:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20936 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3HLAUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 20:20:42 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FH1vjDVfDs8A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=tRcXAVgreYAA:10 a=20KFwNOVAAAA:8 a=E93I8Hx2fu6z3KFfOcMA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=uQ-X8t-2eB8A:10 a=u81wb_fookoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Sun, 11 Aug 2013 20:20:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] tracing: kill the no longer needed PITA code
Message-ID: <20130811202040.4812c568@gandalf.local.home>
In-Reply-To: <20130811174929.GA12119@redhat.com>
References: <20130731173116.GA31018@redhat.com>
	<1375292913.5418.8.camel@gandalf.local.home>
	<20130811174929.GA12119@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Aug 2013 19:49:29 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> It seems that you have no more 3.11 patches.
> 
> Should I resend this series?

Only if it changed. I'll be looking into 3.12 patches come Monday.

-- Steve

