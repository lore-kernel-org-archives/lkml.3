Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaAPW0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 17:26:03 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48546 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaAPW0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 17:26:01 -0500
Date: Thu, 16 Jan 2014 23:25:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20140116222536.GX30183@twins.programming.kicks-ass.net>
References: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
 <20140116121955.GQ31570@twins.programming.kicks-ass.net>
 <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117074628.88698f59939c9002b7c12968@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 07:46:28AM +1100, Stephen Rothwell wrote:
> Hi Peter,
> 
> On Thu, 16 Jan 2014 13:19:55 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > I think the below ought to work
> 
> To be clear, all you did was replace the body of mwait_idle() with
> 
> 	mwait_idle_with_hints(0, 0);

Pretty much, and add the asm/mwait.h include, otherwise you'll end up
with a compile fail.

> (and the comment above it)?  I need to apply in incremental patch in the
> merge commit.

I don't think I touched the comment at all.
