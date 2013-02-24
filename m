Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3BXOse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:48:34 -0500
Received: from gate.crashing.org ([63.228.1.57]:46956 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170Ab3BXOsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:48:33 -0500
Message-ID: <1361717300.16950.15.camel@pasglop>
Subject: Re: [git pull] signal.git
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Helge Deller <deller@gmx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Date: Sun, 24 Feb 2013 08:48:20 -0600
In-Reply-To: <CA+55aFwx-O4Q=1gKgv=cyG8ObzUyPVh9Ctmuh-DX_DE9rumU5g@mail.gmail.com>
References: <20130220225214.GJ4503@ZenIV.linux.org.uk>
	 <CA+55aFwx-O4Q=1gKgv=cyG8ObzUyPVh9Ctmuh-DX_DE9rumU5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-23 at 18:56 -0800, Linus Torvalds wrote:
> On Wed, Feb 20, 2013 at 2:52 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > * a bunch of signal-related syscalls (both native and compat) unified.
> 
> Ok, in the meantime I had merged the parisc and powerpc trees, which
> had their own fixes in this area: powerpc added the transactional
> memory support for power8 (which impacted signal save/restore), and
> parisc had some fixes to the routines you then removed in favor of
> generic ones.
> 
> I fixed up the conflicts, and they didn't look that bad, but I could
> easily have messed something up, so people - please double-check the
> end result.

At least it builds :-)

It looks fine too. I'll ask Mikey to dbl check the TM stuff.

Thanks !

Cheers,
Ben.

