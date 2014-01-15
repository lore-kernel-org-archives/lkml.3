Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaAOOZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:25:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:51599 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751664AbaAOOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:25:34 -0500
Date: Wed, 15 Jan 2014 09:25:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 01/17] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140115092532.56d9ad44@gandalf.local.home>
In-Reply-To: <20140115141519.GB16016@ghostprotocols.net>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-2-git-send-email-namhyung@kernel.org>
	<20140114210058.6b75c47a@gandalf.local.home>
	<87k3e29cxz.fsf@sejong.aot.lge.com>
	<20140114215655.666d7480@gandalf.local.home>
	<87fvopalbb.fsf@sejong.aot.lge.com>
	<20140115141519.GB16016@ghostprotocols.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 11:15:19 -0300
Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Wed, Jan 15, 2014 at 02:03:20PM +0900, Namhyung Kim escreveu:
> > On Tue, 14 Jan 2014 21:56:55 -0500, Steven Rostedt wrote:
> > > On Wed, 15 Jan 2014 11:49:28 +0900
> > > Namhyung Kim <namhyung@kernel.org> wrote:
> > >> Oh, it looks better.  But I'd like to TRACE_SEQ_CHECK() as is for some
> > >> cases.  How about this?
> > >
> > > Looks good to me.
> > >
> > > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> > >
> > > I'll try to look at the rest of the patches tomorrow.
> 
> Hi Steven, can I keep your ackd-by?
>  

Yep.

-- Steve

