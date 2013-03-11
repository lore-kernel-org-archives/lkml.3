Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3CKOYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 10:24:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3CKOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 10:24:41 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=4dEJddBKX3AA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=lrVzYC5FtwsA:10 a=VLD9ylkaxfSdWlIIy78A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363011880.12608.17.camel@gandalf.local.home>
Subject: Re: [PATCH 00/13] Improvements tracing code
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Mon, 11 Mar 2013 10:24:40 -0400
In-Reply-To: <513D8414.9040005@huawei.com>
References: <513D8414.9040005@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 15:13 +0800, zhangwei(Jovi) wrote:
> This patch series does several improvements and cleanups in tracing code
> as follows short stat.

Except for the patches I replied to (and scsi), I think the rest are
fine and will queue them up in my 3.10 series.

These are:

zhangwei(Jovi) (7):
  tracing: teach to use pr_warn_once
  tracing: use TRACE_MAX_PRINT
  tracing: move find_event_field function into trace_events.c
  tracing: make trace_destroy_fields as static
  tracing: change unclear comments on arch_syscall_match_sym_name
  tracing: rename trace_event_mutex to trace_event_sem
  tracing: deprecate tracing_is_enabled function

-- Steve


