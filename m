Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965633Ab3FTSmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:42:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935390Ab3FTSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:42:54 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=_3TNz7i6i5EA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=-UAzvdOwPQcA:10 a=1JMbdkPMGwrRFDLqK_YA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371753773.18733.102.camel@gandalf.local.home>
Subject: Re: [PATCH v2 0/4] tracing/kprobes: perf_trace_buf_*() optimization
 + cleanups
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Jun 2013 14:42:53 -0400
In-Reply-To: <20130620173748.GA13133@redhat.com>
References: <20130620173748.GA13133@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 19:37 +0200, Oleg Nesterov wrote:
> Steven,
> 
> Please consider this series for inclusion. It doesn't depend on
> other changes we are discussing.
> 
> Only cosmetic changes since v1, everything was acked by Masami.
> 


Not that I don't trust you :-)

But Masami, can you Ack all these patches one more time. I like to have
the Acked-by, a direct reply to the patches I pull. It's also fine to
reply to this email with "All patches in this series: Acked-by: ... " So
you don't need to reply to each patch individually.

Thanks,


-- Steve


