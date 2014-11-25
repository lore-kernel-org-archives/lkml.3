Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKYWLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:11:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaKYWLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:11:31 -0500
Date: Tue, 25 Nov 2014 16:10:46 -0600
From: Seth Jennings <sjenning@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 0/3] Kernel Live Patching
Message-ID: <20141125221046.GA12000@medulla.variantweb.net>
References: <1416935709-404-1-git-send-email-sjenning@redhat.com>
 <alpine.LNX.2.00.1411252017010.23174@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1411252017010.23174@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 08:26:22PM +0100, Jiri Kosina wrote:
> On Tue, 25 Nov 2014, Seth Jennings wrote:
> 
> > Masami's IPMODIFY patch is heading for -next via your tree.  Once it arrives,
> > I'll rebase and make the change to set IPMODIFY.  Do not pull this for -next
> > yet.  This version (v4) is for review and gathering acks.
> 
> Thanks for sending out v4 and incorporating the feedback, I really 
> appreciate your responsiveness!
> 
> Anyway, I don't think targetting 3.19 is realistic, given we're currently 
> already past 3.18-rc6 ... even if we rush it into -next in the coming 
> days, it will get close to zero exposure in there before the merge window 
> opens.

Agreed. Sorry if I gave the impression that I was trying to rush this
into 3.19.  I just wanted to make sure that Steve was aware of the
dependency.

> 
> I'd like to do quite some more testing and still finish some pending 
> portions of code reviews on our side (especially to make sure that this 
> can be easily extended to support any consistency model in the future).

Without knowing how that consistency code will look, how can we "make
sure" that this code can be easily extended to support it?  I don't
think we should hold up this first step based on what we think the
consistency code might look like. The code is not that complex right
now. That was the point :)  We can always adapt things.

> 
> Once we start collecting Reviewed-by's / Acked-by's on this patchset, I 
> can establish a tree on git.kernel.org that we can use to collect any 
> followup patches during 3.20 development cycle and send a pull request to 
> Linus during 3.20 merge window .. if everybody agrees with this course of 
> action, obviously.

I was hoping this first step would go into next via Steve's tree and go
upstream for 3.20 (hopefully) from there.  I would be against anything
that tries to expand the feature set before this base functionality gets
upstream.  However, if we want to have a tree to gather fixes before
3.20, which I think is what you are suggesting, that works for me.  We
would need to agree explicitly that, in this tree, patches would need
both a RH and SUSE ack to be accepted.

Thanks,
Seth

> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
