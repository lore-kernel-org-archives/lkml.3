Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEGTlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:41:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:16662 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751315AbaEGTlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:41:14 -0400
Date: Wed, 7 May 2014 15:41:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Romain Izard <romain.izard.pro@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: module: Maintain a valid user count
Message-ID: <20140507154111.6ba752cb@gandalf.local.home>
In-Reply-To: <20140507192335.GA23409@gmail.com>
References: <20140303133330.7031b2cb@gandalf.local.home>
	<1393924179-9147-1-git-send-email-romain.izard.pro@gmail.com>
	<20140306123403.5f29c071@gandalf.local.home>
	<20140507192335.GA23409@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 21:23:36 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Ingo,
> > 
> > You want to push this to Linus?
> > 
> > Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> 
> I think it would be more natural through the tracing tree, through 
> which most tracepoint fixes go, agreed?
> 

Hmm, yeah. Not sure why I pushed it off to you :-/

Looks like this should be marked as stable and incorporated in 3.15 as
well.

Thanks,

-- Steve
