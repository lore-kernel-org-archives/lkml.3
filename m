Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaLARMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 12:12:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40008 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaLARMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 12:12:02 -0500
Date: Mon, 1 Dec 2014 11:11:05 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/3] samples: add sample live patching module
Message-ID: <20141201171105.GB11179@cerebellum.variantweb.net>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <1416935709-404-4-git-send-email-sjenning@redhat.com>
 <20141127170513.GA22608@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127170513.GA22608@pathway.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 06:05:13PM +0100, Petr Mladek wrote:
> On Tue 2014-11-25 11:15:09, Seth Jennings wrote:
> > Add a sample live patching module.
> > 
> > Signed-off-by: Seth Jennings <sjenning@redhat.com>
> > ---
> >  MAINTAINERS                          |  1 +
> >  samples/Kconfig                      |  7 +++
> >  samples/livepatch/Makefile           |  1 +
> >  samples/livepatch/livepatch-sample.c | 87 ++++++++++++++++++++++++++++++++++++
> >  4 files changed, 96 insertions(+)
> >  create mode 100644 samples/livepatch/Makefile
> >  create mode 100644 samples/livepatch/livepatch-sample.c
> 
> [...] 
> 
> > diff --git a/samples/livepatch/Makefile b/samples/livepatch/Makefile
> > new file mode 100644
> > index 0000000..7f1cdc1
> > --- /dev/null
> > +++ b/samples/livepatch/Makefile
> > @@ -0,0 +1 @@
> > +obj-$(CONFIG_SAMPLE_LIVE_PATCHING) += livepatch-sample.o
> > diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> > new file mode 100644
> > index 0000000..21f159d
> 
> The Makefile is ignored because there is missing:
> 
> 
> diff --git a/samples/Makefile b/samples/Makefile
> index 1a60c62e2045..f00257bcc5a7 100644
> --- a/samples/Makefile
> +++ b/samples/Makefile
> @@ -1,4 +1,4 @@
>  # Makefile for Linux samples code
>  
> -obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
> +obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
>  			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/

Applied, thanks!

Seth

> 
> 
> Best Regards,
> Petr
> --
> To unsubscribe from this list: send the line "unsubscribe live-patching" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
