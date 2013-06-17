Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3FQQx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:53:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6411 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3FQQxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:53:25 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=SMDSOe-kd8UA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=f_7vHL-JqRIA:10 a=3nbZYyFuAAAA:8 a=MZimOrTAiNa2M6GW6a8A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371488003.18733.19.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing/kprobes: remove unnecessary checking of,
 trace_probe_is_enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Date: Mon, 17 Jun 2013 12:53:23 -0400
In-Reply-To: <51BA87DB.1020403@hitachi.com>
References: <51BA7B9E.3040807@huawei.com> <51BA87DB.1020403@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 12:02 +0900, Masami Hiramatsu wrote:
> (2013/06/14 11:10), zhangwei(Jovi) wrote:
> > Since tp->flags assignment was moved into function enable_trace_probe,
> > so there have no need to use trace_probe_is_enabled to check flags
> > in same function.
> 
> Indeed :)
> 
> > 
> > Remove the unnecessary checking.
> 
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 

Thanks, I added this to my 3.11 queue.

-- Steve


