Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaGVIAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:00:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:59023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaGVIAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:00:18 -0400
Date: Tue, 22 Jul 2014 10:00:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
Message-ID: <20140722080016.GY3935@laptop>
References: <20140719130602.GA5101@pd.tnic>
 <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic>
 <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic>
 <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
 <20140721220825.GE11555@pd.tnic>
 <CALCETrXOpcegDp+eUTWqDkO0jWqgJNYhKJW=HbzvT1ga4Ekxog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXOpcegDp+eUTWqDkO0jWqgJNYhKJW=HbzvT1ga4Ekxog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 03:13:33PM -0700, Andy Lutomirski wrote:
> >> I actually own one of these systems.  It's a Sandy Bridge Core-i7
> >> Extreme or something like that.
> >
> > Ha, cool, so I've got my tester! :-)
> 
> Ha.  Ha ha.  Muahaha.  Because IIRC this box is synced until the first
> time it suspends.

Oh cute, one of those :-) Yes some BIOSes write 'random' crap into the
TSC when doing the S states jig. We have some tsc suspend/resume hooks
to correct the worst of that, but yeah screwy that.
