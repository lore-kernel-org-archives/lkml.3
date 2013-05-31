Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3EaLku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:40:50 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59234 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3EaLkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:40:42 -0400
Date: Fri, 31 May 2013 13:40:37 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Russ Anderson <rja@sgi.com>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531114037.GC7131@gmail.com>
References: <20130524074331.GL14575@console-pimps.org>
 <20130529210115.GC28027@sgi.com>
 <alpine.LRH.2.00.1305300018180.1111@twin.jikos.cz>
 <20130529224645.GA16582@sgi.com>
 <alpine.LNX.2.00.1305300048520.30576@pobox.suse.cz>
 <1369880172.17397.11.camel@linux-s257.site>
 <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 31 May 2013, Ingo Molnar wrote:
> 
> > > Unfortunately that means that you can as well throw the patch away 
> > > completely.
> > >
> > > The sole point is to run the QueryVariableInfo() from the boot 
> > > environment, in order to obtain more accurate information. And it's 
> > > a valid thing to do, according to UEFI specification.
> >
> > So this change needs to be reverted or fixed.
> 
> I don't think anyone is arguing against that.

The statement I replied to above can be fairly read as arguing against it.

Anyway, given that the fix (workaround) from Boris seems elaborate so late 
in the v3.10 cycle, does everyone else agree with a revert as well?

Thanks,

	Ingo
