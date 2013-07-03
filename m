Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab3GCLjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:39:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32980 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GCLjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:39:08 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=3fHPkcu3S-gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-RI5mPAZ62QA:10 a=FPxnZP9nvSWfFS7ZPfUA:9 a=QEXdDO2ut3YA:10 a=UuQ-TzSEZ30A:10 a=uL2S8LFpx_0A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372851547.22688.95.camel@gandalf.local.home>
Subject: Re: [PATCH v3 11/12] tracing: guard tracing_selftest_disabled by
 CONFIG_FTRACE_STARTUP_TEST
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 03 Jul 2013 07:39:07 -0400
In-Reply-To: <51D3A495.3080908@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	  <1365564393-10972-12-git-send-email-jovi.zhangwei@huawei.com>
	 <1372809403.22688.90.camel@gandalf.local.home>
	 <51D3A495.3080908@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 12:12 +0800, zhangwei(Jovi) wrote:

> Ok, we can leave the __read_mostly attribute.
> 
> And tracing_selftest_disabled still can move to CONFIG_FTRACE_STARTUP_TEST
> guard, normally CONFIG_FTRACE_STARTUP_TEST is disabled in most system.
> 
> Do I need to resend this patch?
> 

Yes please. I don't like to modify someone else patch that makes in no
longer match the change log.

-- Steve


