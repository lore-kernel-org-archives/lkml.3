Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492Ab3BXDZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 22:25:37 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39098 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379Ab3BXDZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 22:25:36 -0500
Date: Sun, 24 Feb 2013 03:25:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [git pull] signal.git
Message-ID: <20130224032527.GT4503@ZenIV.linux.org.uk>
References: <20130220225214.GJ4503@ZenIV.linux.org.uk>
 <CA+55aFwx-O4Q=1gKgv=cyG8ObzUyPVh9Ctmuh-DX_DE9rumU5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwx-O4Q=1gKgv=cyG8ObzUyPVh9Ctmuh-DX_DE9rumU5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 06:56:02PM -0800, Linus Torvalds wrote:
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

Ouch...  Lesson for me - before hitting send, check if anything relevant
has arrived while the mail was being written...
