Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaAPIdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 03:33:10 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:57119 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaAPIdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 03:33:08 -0500
Date: Thu, 16 Jan 2014 09:33:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/13] tools lib traceevent: Get rid of die() finally!!
Message-ID: <20140116083302.GA6077@gmail.com>
References: <1389817991-8145-1-git-send-email-acme@infradead.org>
 <1389817991-8145-8-git-send-email-acme@infradead.org>
 <20140115161736.67c5f1e5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115161736.67c5f1e5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 15 Jan 2014 17:33:05 -0300
> Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> 
> > From: Namhyung Kim <namhyung@kernel.org>
> > 
> > Now all of its users were gone. :)
> > 

Now that all users of death are dead, death can die as well?

> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > Reviewed-by: Jiri Olsa <jolsa@redhat.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Jiri Olsa <jolsa@redhat.com>
> > Cc: Namhyung Kim <namhyung.kim@lge.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> I just couldn't bring myself to Ack the death of die! }-,:

Indeed not something to ack to death!

Thanks,

	Ingo
