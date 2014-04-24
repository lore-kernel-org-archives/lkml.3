Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbaDXRkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:40:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11431 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753483AbaDXRkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:40:04 -0400
Date: Thu, 24 Apr 2014 13:39:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiaxing Wang <wangjiaxing@insigma.com.cn>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing:Do not profile dumpstack utilities to fix stack
 trace output
Message-ID: <20140424133955.0804f30b@gandalf.local.home>
In-Reply-To: <53530AF7.7020807@insigma.com.cn>
References: <1397893546-7465-1-git-send-email-wangjiaxing@insigma.com.cn>
	<20140419111820.2a8a3ac8@gandalf.local.home>
	<53530AF7.7020807@insigma.com.cn>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2014 07:47:03 +0800
Jiaxing Wang <wangjiaxing@insigma.com.cn> wrote:

> So the problem is caused by dumpstack utilities get traced by function_graph
> tracer, and disable the profiling of them fixes this.

OK, that makes sense. Thanks.

-- Steve
