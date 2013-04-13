Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab3DMBRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 21:17:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58789 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3DMBRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 21:17:34 -0400
Subject: Re: [PATCH 5/6] tools lib traceevent: Add page_size field to pevent
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1365691255.9609.34.camel@gandalf.local.home>
References: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
	 <1365681898-19897-5-git-send-email-namhyung@kernel.org>
	 <1365691175.9609.33.camel@gandalf.local.home>
	 <1365691255.9609.34.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Apr 2013 10:17:26 +0900
Message-ID: <1365815846.1769.11.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

2013-04-11 (목), 10:40 -0400, Steven Rostedt:
> On Thu, 2013-04-11 at 10:39 -0400, Steven Rostedt wrote:
> > On Thu, 2013-04-11 at 21:04 +0900, Namhyung Kim wrote:
> > > From: Namhyung Kim <namhyung.kim@lge.com>
> > > 
> > > It's for saving the page size of traced system.
> > 
> > Can you add a bit more detail in the change log about why this patch is
> > necessary.
> 
> For now, you can add my
> 
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> for all but this patch.

Thanks!

> 
> I just want to know more about this patch before I ack it.

The page size of traced system can be different than current system's
because the recorded data file might be analyzed in a different machine.
In this case we should use original page size of traced system when
accessing the data file, so this information needs to be saved.

Thanks,
Namhyung


