Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaEHWke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 18:40:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:59348 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbaEHWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 18:40:33 -0400
Date: Fri, 9 May 2014 00:40:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC PATCH] ftrace/x86: Move the mcount/fentry code out of
 entry_64.S
In-Reply-To: <20140508183752.19e99780@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405090040320.6261@ionos.tec.linutronix.de>
References: <20140508152152.2130e8cf@gandalf.local.home> <alpine.DEB.2.02.1405090019510.6261@ionos.tec.linutronix.de> <20140508183752.19e99780@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Steven Rostedt wrote:

> On Fri, 9 May 2014 00:21:37 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 8 May 2014, Steven Rostedt wrote:
> > 
> 
> > I'm fine with the code move per se. That's a good thing.
> 
> Great, then I'll add this to my 3.16 queue.
> 
> Can I get your Acked-by for it?

Sure
