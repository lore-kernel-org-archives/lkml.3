Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbbAFVVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:21:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbAFVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:21:03 -0500
Date: Tue, 6 Jan 2015 13:21:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kgdb-next not pushed to Linus for 3.19
Message-Id: <20150106132102.65ad5988fc566357450e3d65@linux-foundation.org>
In-Reply-To: <1420570662.2652.36.camel@perches.com>
References: <54AC2F5D.9050405@linaro.org>
	<1420570662.2652.36.camel@perches.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Jan 2015 10:57:42 -0800 Joe Perches <joe@perches.com> wrote:

> On Tue, 2015-01-06 at 18:54 +0000, Daniel Thompson wrote:
> > Hi Jason
> > 
> > I'm trying to figure out what to do with my long-outstanding kgdb/kdb
> > patches in preparation for the 3.20 merge window.
> > 
> > As of now I have five pending patch sets some of which are well over six
> > months old (and none have nay outstanding review comments).
> > 
> > When I raised this with you a couple of months ago, two of the patch
> > sets did land in your kgdb-next tree. However nothing seems to have
> > happened since then and I couldn't find any messages from you during the
> > 3.19 merge window.
> > 
> > I'm afraid I don't know what else I need to do to progress things.
> > 
> > I do plan to do routine rebasing and resending of my patchsets but,
> > based on the past experience, that seems unlikely to be enough to get
> > the code delivered in 3.20.
> > 
> > Do you think I would be better sending these patches via someone else?
> > In any case, advice would be very welcome.
> 
> Andrew?
> 
> I think Daniel's kgdb patches are bug fixes.
> 
> Can you please pick them up?

yup.  Merging patches which are already in -next is a bit of a pain,
but I'll cope.

Daniel, can you please resend everything in a nice clean coherent
stream?

