Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaAPBxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:53:08 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:22452 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750941AbaAPBxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:53:06 -0500
Date: Wed, 15 Jan 2014 20:52:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/17] tools lib traceevent: Add
 pevent_unregister_event_handler()
Message-ID: <20140115205259.017a644f@gandalf.local.home>
In-Reply-To: <52D7211C.9030903@lge.com>
References: <1389750340-15965-1-git-send-email-namhyung@kernel.org>
	<1389750340-15965-7-git-send-email-namhyung@kernel.org>
	<20140115111839.73d85422@gandalf.local.home>
	<52D7211C.9030903@lge.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 09:00:28 +0900
Namhyung Kim <namhyung.kim@lge.com> wrote:

> Hi Steve,
> 
> 2014-01-16 AM 1:18, Steven Rostedt wrote:
> > On Wed, 15 Jan 2014 10:45:29 +0900
> > Namhyung Kim <namhyung@kernel.org> wrote:
> >> +	if (event->handler == func && event->context == context) {
> >> +		pr_stat("overriding event (%d) %s:%s with default print handler",
> >
> > Should we use the word "overriding" again? Perhaps saying:
> >
> > "removing override print handler (%d) %s:%s. Going back to default handler."
> >
> > Or something?
> 
> What about this:
> 
> "removing override handler for event (%d) %s:%s. Going back to default 
> handler."
> 

Sounds good.

-- Steve
