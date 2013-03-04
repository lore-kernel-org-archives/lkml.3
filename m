Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3CDNu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:50:58 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:63470 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683Ab3CDNu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:50:57 -0500
MIME-Version: 1.0
In-Reply-To: <51347359.80709@huawei.com>
References: <51347359.80709@huawei.com>
Date: Mon, 4 Mar 2013 14:50:55 +0100
Message-ID: <CAFTL4hy0UDew8vN8OACppCKmauUYLNHNv2U55a6JmdPMovCi3g@mail.gmail.com>
Subject: Re: [PATCH] printk/tracing: rework console tracing
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/4 zhangwei(Jovi) <jovi.zhangwei@huawei.com>:
> From 0a2bd3ad03fc9acd125f4eeb585a1e09027a182a Mon Sep 17 00:00:00 2001
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

Very welcome simplification!

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
