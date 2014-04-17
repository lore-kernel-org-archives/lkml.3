Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaDQOna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:43:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54240 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbaDQOnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:43:19 -0400
Date: Thu, 17 Apr 2014 10:43:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/uprobes: fix uprobe_cpu_buffer memory leak
Message-ID: <20140417104311.142458ca@gandalf.local.home>
In-Reply-To: <1397741484.1731.11.camel@leonhard>
References: <1397741484.1731.11.camel@leonhard>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 22:31:24 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Jovi,
> 
> (Sorry for replying in another thread.  I don't have an access to the
> company mail at home.)
> 
> On Thu, Apr 17, 2014 at 04:05:19PM +0800, "zhangwei(Jovi)" wrote:
> > Forgot to free uprobe_cpu_buffer percpu page in uprobe_buffer_disable.
> 
> Thanks for fixing this!
> 
> Acked-by: Namhyung Kim <namhyung@kernel.org>

I'm running this through my tests right now.

Thanks!

-- Steve

