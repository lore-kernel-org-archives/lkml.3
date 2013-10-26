Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3JZKLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 06:11:00 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:61005 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3JZKK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 06:10:59 -0400
Date: Sat, 26 Oct 2013 12:10:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86-ML <x86@kernel.org>
Subject: Re: [GIT PULLv2] For x86/mce ... enhanced error logs
Message-ID: <20131026101055.GB14949@gmail.com>
References: <5266bc543597964da@agluck-desk.sc.intel.com>
 <52680aa01445165d7@agluck-desk.sc.intel.com>
 <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbL8eO=4EGLwRhdLVDndRqX=uHJz3-EKzT=PJ-Bv0a-K2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@gmail.com> wrote:

> On Wed, Oct 23, 2013 at 10:42 AM, Luck, Tony <tony.luck@intel.com> wrote:
> > Replacement for yesterday's pull request - fixes a build bug when CONFIG_SMP=n
> > found by Fengguang's zero-day auto-build robot army.  If you pulled (and pushed)
> > that one before finding this in your mailbox - then I can send the one-line
> > patch to be applied on top of yesterday's version.
> 
> Well - I might as well put the brown paper bag over my head and go sit
> in the corner :-(
> 
> I accidentally applied an extra patch "UEFI, CPER: Move cper.c to a
> more proper place"
> that Chen Gong had sent to me internally but has only been mentioned
> in concept on the mailing list.

Hm, I'm not sure we should move something named after a hardware 
feature into lib/. It's not really generic C library functionality, 
is it?

> So feel free to pop the 10th patch off and drop it.

Yeah, I did that.

Thanks,

	Ingo
