Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaEHGOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:14:55 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38182 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaEHGOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:14:54 -0400
Date: Thu, 8 May 2014 08:14:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>, Romain Izard <romain.izard.pro@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: module: Maintain a valid user count
Message-ID: <20140508061449.GC31184@gmail.com>
References: <20140303133330.7031b2cb@gandalf.local.home>
 <1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com>
 <20140306123403.5f29c071@gandalf.local.home>
 <20140507192335.GA23409@gmail.com>
 <20140507154111.6ba752cb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507154111.6ba752cb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 7 May 2014 21:23:36 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Ingo,
> > > 
> > > You want to push this to Linus?
> > > 
> > > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > I think it would be more natural through the tracing tree, through 
> > which most tracepoint fixes go, agreed?
> > 
> 
> Hmm, yeah. Not sure why I pushed it off to you :-/

To check whether I'm awake, I'm sure!

> Looks like this should be marked as stable and incorporated in 3.15 
> as well.

Yeah.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
