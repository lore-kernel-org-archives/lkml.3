Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab3GXThq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:37:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab3GXThp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:37:45 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5Iol3hfF0AcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=IQWIQEpUQO0A:10 a=3TuId8C8iOE9jW-VE3QA:9 a=QEXdDO2ut3YA:10 a=6jOphKy1ZAQA:10 a=BADnC57__FIA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374694662.3356.148.camel@gandalf.local.home>
Subject: Re: [PATCH 2/6] tracing: Change event_enable/disable_read() to
 verify i_private != NULL
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 24 Jul 2013 15:37:42 -0400
In-Reply-To: <20130723205913.GA9058@redhat.com>
References: <20130723205913.GA9058@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 22:59 +0200, Oleg Nesterov wrote:
> @@ -732,7 +741,6 @@ event_enable_write(struct file *filp, const char
> __user *ubuf, size_t cnt,
>         }
>  
>         *ppos += cnt;
> -
>         return ret ? ret : cnt;
>  } 

Actually, I prefer the space.

-- Steve


