Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab3CDOta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:49:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24342 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3CDOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:49:29 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-oqmaCl2xZ4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=JxIrrjbTLTcA:10 a=i0EeH86SAAAA:8 a=0fKGY_m__xB9fWVvoOYA:9 a=PUjeQqilurYA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362408567.31874.17.camel@gandalf.local.home>
Subject: Re: [PATCH] printk/tracing: rework console tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 04 Mar 2013 09:49:27 -0500
In-Reply-To: <51347359.80709@huawei.com>
References: <51347359.80709@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 18:11 +0800, zhangwei(Jovi) wrote:
> >From 0a2bd3ad03fc9acd125f4eeb585a1e09027a182a Mon Sep 17 00:00:00 2001
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> Date: Mon, 4 Mar 2013 17:45:10 +0800
> Subject: [PATCH] printk/tracing: rework console tracing
> 
> commit 7ff9554bb(printk: convert byte-buffer to variable-length record buffer)
> removed start and end parameters in call_console_drivers,
> but those parameters still exists in include/trace/events/printk.h.
> 
> Without start and end parameters handling, printk tracing became more simple as:
>     trace_console(text, len);
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> ---

Acked-by: Steven Rostedt <rostedt@goodmis.org>

Who wants to take this? I can pull it into my 3.10 queue if no one else
wants to process this.

-- Steve


