Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3H2OTY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:19:24 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59725 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3H2OTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:19:20 -0400
MIME-Version: 1.0
Date: Thu, 29 Aug 2013 19:41:28 +0530
Message-ID: <CAJ_BOiB6E4D-Y45VZTOGqhYMs_FG8UTpGnNdzjdj3nEP13A=3g@mail.gmail.com>
Subject: wakeup tracer not able to capture traces on 3.4 kernel
From: Prabhat Kumar Ravi <prabhatravi09@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I trying to capture traces through wakeup tracer, but not able to
capture it on 3.4 kernel with cortex A9 processor, armv7.
{{{
/ # mount -t debugfs nodev /debug
/ # sysctl kernel.ftrace_enabled=1
kernel.ftrace_enabled = 1
/ # echo wakeup > /debug/tracing/current_tracer
/ # echo latency-format > /debug/tracing/trace_options
/ # echo 0 > /debug/tracing/tracing_max_latency
/ # echo 1 > /debug/tracing/tracing_on
/ # sleep 10
/ # echo 0 > /debug/tracing/tracing_on
/ # cat /debug/tracing/trace
# tracer: wakeup
#
}}}

Please suggest me where I am wrong.

Regards,
Prabhat
