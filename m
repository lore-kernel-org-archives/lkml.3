Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3G3CBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 22:01:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3G3CBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 22:01:41 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ZgYRSZqRWO8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=6PEQZdHCN9wA:10 a=3nbZYyFuAAAA:8 a=5_lkDTT39hjBKQWGUxMA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=h2Mh8ob_nCkA:10 a=F8gF8Te7fPcA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375149700.6580.61.camel@gandalf.local.home>
Subject: Re: [PATCH v3 6/6] tracing: Change remove_event_file_dir() to clear
 "d_subdirs"->i_private
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Jul 2013 22:01:40 -0400
In-Reply-To: <51F71891.3030508@hitachi.com>
References: <20130726172513.GA3586@redhat.com>
	 <20130726172551.GA3632@redhat.com> <20130728183527.GB16723@redhat.com>
	 <51F71891.3030508@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 10:36 +0900, Masami Hiramatsu wrote:

> Looks good for me.
> 
> Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

I've applied them all locally, but I'll rebase and add your reviewed-by
tags. (also make some other checks)  Then I need to rerun them through
my main tests before I post them to next, and then onto Linus.

Thanks to both of you,

-- Steve


