Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbaE1RlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:41:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:47239 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751962AbaE1RlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:41:24 -0400
Date: Wed, 28 May 2014 13:41:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is
 in use
Message-ID: <20140528134120.3328605e@gandalf.local.home>
In-Reply-To: <20140528172618.GB17220@pd.tnic>
References: <20140528131440.2283213c@gandalf.local.home>
	<20140528172618.GB17220@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 19:26:18 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Wed, May 28, 2014 at 01:14:40PM -0400, Steven Rostedt wrote:
> > Here's the banner:
> > 
> >  ****************************************
> >  ** NOTICE NOTICE NOTICE NOTICE NOTICE **
> >  ** trace_printk() being used.         **
> >  ** Allocating extra memory for it     **
> >  ****************************************
> > 
> > Hmm, maybe I should add "Not for production use" to scare people even
> > more?
> 
> Yes, and at least some swearing - this is the linux kernel for
> chrissake. Or are you gone soft too?
> 

Going soft? Nah, you know me.  I never swear, so how could not swearing
cause me to go soft :-)


Perhaps a: 

  *********************************************************
  ** NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **
  **                                                     **
  ** trace_printk() being used.                          **
  ** Allocating extra memory for it                      **
  **                                                     **
  ** This means that this is a DEBUG kernel and it is    **
  ** unsafe for production use.                          **
  **                                                     **
  ** If you see this message and you are not debugging   **
  ** the kernel, report this immediately to your vendor! **
  **                                                     **
  ** NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE    **
  *********************************************************

Maybe that will work?

-- Steve
