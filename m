Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaJUKOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:14:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaJUKOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:14:17 -0400
Date: Tue, 21 Oct 2014 12:14:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cmpxchg: Discard unnecessary cast to volatile
Message-ID: <20141021101412.GS23531@worktop.programming.kicks-ass.net>
References: <1412186248-18672-1-git-send-email-bobby.prani@gmail.com>
 <CAJhHMCDhhoxj25pmkxO2AhLwj6ur9ga3yRcViuH+DU-8K+Ch5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCDhhoxj25pmkxO2AhLwj6ur9ga3yRcViuH+DU-8K+Ch5g@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:22:27PM -0400, Pranith Kumar wrote:
> > Generating a volatile pointer is really not necessary here. This is the only
> > location where a volatile pointer is being generated for use in asm.
> >
> > This commit removes the unnecessary volatile pointer being created.
> >
> > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

Seems sane enough to me.
