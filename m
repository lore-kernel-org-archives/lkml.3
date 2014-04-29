Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316AbaD2WTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:19:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:39827 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965300AbaD2WTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:19:34 -0400
Date: Tue, 29 Apr 2014 18:19:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bharath Ravi <rbharath@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Laurent Chavey <chavey@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tracing: Allow changing default ring buffer size for
 ftrace instances.
Message-ID: <20140429181929.01885052@gandalf.local.home>
In-Reply-To: <CAHN2JJ8WmyPPnVyJJxFg-OFJwrb9c6VuG5bUhkM82hjd3nwU4g@mail.gmail.com>
References: <CAHN2JJ_hOS=jfvGUZFt=mx5ymCOmJrUdP1ATnOXe-D9MvtgAMg@mail.gmail.com>
	<20140425135219.3ad56e1b@gandalf.local.home>
	<CAHN2JJ8WmyPPnVyJJxFg-OFJwrb9c6VuG5bUhkM82hjd3nwU4g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 15:09:15 -0700
Bharath Ravi <rbharath@google.com> wrote:

> We'd actually considered doing just that, in an initial version of the patch.
> At the time, we'd decided in favour of allowing the user more explicit
> control over the buffer size, rather than auto expanding it. (The
> discussion on that is here:
> https://lkml.org/lkml/2013/7/1/617)

Yeah, I remember my rational :-)

The thing is, I have been thinking more about it, and I'm now thinking
it would be fine. But reading that email again, I may have convinced
myself that it should have the option. Gah, I'm now arguing with myself!

> 
> We could go back to that though if you think that's okay, but I think
> your previous reasoning still makes sense: it's useful for the user to
> know if there will be an allocation failure before enabling tracing.

Grumble. I need to think about this a bit more. I'm stretching myself a
bit thin between different projects. I'll pull in you patches and play
with it a bit and then come back with a decision.

Thanks!

-- Steve
