Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677Ab3G3Bmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:42:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32270 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3G3Bmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:42:54 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=kMZWV0aksHEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=hrHXKxf5CJcA:10 a=yq2aOLSuhV-PyUnt4IYA:9 a=QEXdDO2ut3YA:10 a=h2Mh8ob_nCkA:10 a=Mcgi3Q1aEU8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375148571.6580.57.camel@gandalf.local.home>
Subject: Re: [PATCH v2 2/6] tracing: Change event_enable/disable_read() to
 verify i_private != NULL
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
Date: Mon, 29 Jul 2013 21:42:51 -0400
In-Reply-To: <51F7176D.6000907@hitachi.com>
References: <20130726172536.GA3612@redhat.com>
	 <51F7176D.6000907@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-30 at 10:31 +0900, Masami Hiramatsu wrote:

> BTW, this still has a cosmetic change, is that OK for Steven?
> 

> >  	strcat(buf, "\n");
> > -
> >  	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
> >  }
> >  

You mean the above? Don't worry, I removed it ;-)

I don't usually touch patches, but whitespace changes like this are not
worthy of even a mention.

-- Steve


