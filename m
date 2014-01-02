Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaABVCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:02:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6270 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751172AbaABVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:02:20 -0500
Date: Thu, 2 Jan 2014 16:02:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 15/17] tracing/uprobes: Add support for full argument
 access methods
Message-ID: <20140102160218.6e9ee4a4@gandalf.local.home>
In-Reply-To: <20140102155827.21b552e0@gandalf.local.home>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
	<1387168336-13213-16-git-send-email-namhyung@kernel.org>
	<20140102155827.21b552e0@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jan 2014 15:58:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 16 Dec 2013 13:32:14 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Enable to fetch other types of argument for the uprobes.  IOW, we can
> > access stack, memory, deref, bitfield and retval from uprobes now.
> > 
> > The format for the argument types are same as kprobes (but @SYMBOL
> > type is not supported for uprobes), i.e:
> > 
> >   @ADDR   : Fetch memory at ADDR
> >   $stackN : Fetch Nth entry of stack (N >= 0)
> >   $stack  : Fetch stack address
> >   $retval : Fetch return value
> >   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address
> > 
> > Note that the retval only can be used with uretprobes.
> > 
> > Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
> 
> Where was the original patch posted? And can we get Hyeoncheol's SOB for
> this?
> 

Was this the other part of patch 11? Still should have Hyeoncheol's
signed-off-by. If you already had it on the original (before the split)
then we can add it here too, as he already signed off on the code that
this was based on.

-- Steve
