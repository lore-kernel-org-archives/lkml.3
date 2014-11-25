Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaKYWWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:22:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbaKYWWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:22:00 -0500
Date: Tue, 25 Nov 2014 23:22:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Seth Jennings <sjenning@redhat.com>
cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
In-Reply-To: <20141125221046.GA12000@medulla.variantweb.net>
Message-ID: <alpine.LNX.2.00.1411252313190.23174@pobox.suse.cz>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com> <alpine.LNX.2.00.1411252017010.23174@pobox.suse.cz> <20141125221046.GA12000@medulla.variantweb.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014, Seth Jennings wrote:

> > I'd like to do quite some more testing and still finish some pending 
> > portions of code reviews on our side (especially to make sure that this 
> > can be easily extended to support any consistency model in the future).
> 
> Without knowing how that consistency code will look, how can we "make
> sure" that this code can be easily extended to support it?  

Alright, I probably wasn't precise enough ... I want to make sure that 
whatever path (paths) we chose for future consistency models, we will not 
have to redesign everything from scratch :)

But this is really rather about finishing some of the reviews that are 
still underway on our side.

> > Once we start collecting Reviewed-by's / Acked-by's on this patchset, I 
> > can establish a tree on git.kernel.org that we can use to collect any 
> > followup patches during 3.20 development cycle and send a pull request to 
> > Linus during 3.20 merge window .. if everybody agrees with this course of 
> > action, obviously.
> 
> I was hoping this first step would go into next via Steve's tree and go
> upstream for 3.20 (hopefully) from there.  I would be against anything
> that tries to expand the feature set before this base functionality gets
> upstream.  

Fully agreed. No more "core" features than what your current patchset 
implements should be added before the first merge.

> However, if we want to have a tree to gather fixes before 3.20, which I 
> think is what you are suggesting, that works for me.  

Yup, that's what I am suggesting indeed. I think it makes sense to keep 
this separate from Steven's tree -- we are ftrace users, but we aren't 
touching anything from its internal implementation really.

> We would need to agree explicitly that, in this tree, patches would need 
> both a RH and SUSE ack to be accepted.

Oh, absolutely agreed. Without ack from (at least) everyone in 
MAINTAINERS, nothing will be applied.

I made this suggestion purely to make things easier for everybody 
(especially wrt. merge pull request), not to complicate things by either 
playing political games, nor by having to go through proxy tree (tracing), 
where the "topical link" is rather loose.

Thanks,

-- 
Jiri Kosina
SUSE Labs
