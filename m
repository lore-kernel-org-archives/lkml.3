Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaACBR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:17:27 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63276 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaACBR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:17:26 -0500
X-AuditID: 9c93017d-b7c2eae000004ec2-70-52c60fa4ad13
From: "Hyeoncheol Lee" <cheol.lee@lge.com>
To: "'Steven Rostedt'" <rostedt@goodmis.org>
Cc: "'Namhyung Kim'" <namhyung@kernel.org>,
        "'Oleg Nesterov'" <oleg@redhat.com>,
        "'Masami Hiramatsu'" <masami.hiramatsu.pt@hitachi.com>,
        "'Srikar Dronamraju'" <srikar@linux.vnet.ibm.com>,
        "'zhangwei\(Jovi\)'" <jovi.zhangwei@huawei.com>,
        "'Arnaldo Carvalho de Melo'" <acme@ghostprotocols.net>,
        "'Hemant Kumar'" <hkshaw@linux.vnet.ibm.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Namhyung Kim'" <namhyung.kim@lge.com>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>	<1387168336-13213-16-git-send-email-namhyung@kernel.org>	<20140102155827.21b552e0@gandalf.local.home> <20140102160218.6e9ee4a4@gandalf.local.home>
In-Reply-To: <20140102160218.6e9ee4a4@gandalf.local.home>
Subject: RE: [PATCH 15/17] tracing/uprobes: Add support for full argument access methods
Date: Fri, 3 Jan 2014 10:17:23 +0900
Message-ID: <002d01cf0821$8ee66300$acb32900$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHH0d0TA/nRJ1MZ0RDfagNn9E3EiwF/ht0lAou5anACrSXxpJpK2iUQ
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches look good to me.

Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>

-----Original Message-----
From: Steven Rostedt [mailto:rostedt@goodmis.org] 
Sent: Friday, January 03, 2014 6:02 AM
To: Steven Rostedt
Cc: Namhyung Kim; Oleg Nesterov; Masami Hiramatsu; Srikar Dronamraju;
Hyeoncheol Lee; zhangwei(Jovi); Arnaldo Carvalho de Melo; Hemant Kumar;
LKML; Namhyung Kim
Subject: Re: [PATCH 15/17] tracing/uprobes: Add support for full argument
access methods

On Thu, 2 Jan 2014 15:58:27 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 16 Dec 2013 13:32:14 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Enable to fetch other types of argument for the uprobes.  IOW, we 
> > can access stack, memory, deref, bitfield and retval from uprobes now.
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
> Where was the original patch posted? And can we get Hyeoncheol's SOB 
> for this?
> 

Was this the other part of patch 11? Still should have Hyeoncheol's
signed-off-by. If you already had it on the original (before the split) then
we can add it here too, as he already signed off on the code that this was
based on.

-- Steve

