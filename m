Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaAaG6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 01:58:13 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43788 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAaG6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 01:58:10 -0500
Date: Fri, 31 Jan 2014 07:58:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, zohar@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        lethal@linux-sh.org, x86@kernel.org, james.l.morris@oracle.com
Subject: Re: [PATCH] kconfig: consolidate arch-specific seccomp options
Message-ID: <20140131065804.GA14212@gmail.com>
References: <20140129191011.8FB63DFA@viggo.jf.intel.com>
 <20140130085551.GB2024@gmail.com>
 <52EA8267.4020107@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EA8267.4020107@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Hansen <dave@sr71.net> wrote:

> On 01/30/2014 12:55 AM, Ingo Molnar wrote:
> >> > +	  This kernel feature is useful for number crunching applications
> >> > +	  that may need to compute untrusted bytecode during their
> >> > +	  execution. By using pipes or other transports made available to
> > I'd change and simplify the first sentence to:
> > 
> >> > +	  This kernel feature is useful to sandbox runtimes that need
> >> > +	  to execute untrusted machine code.
> > Seccomp isn't primarily about number crunching anymore, and it's 
> > definitely not about 'bytecode' in the classical sense either.
> 
> I'll change that if I need to send it again.  Otherwise, I'll leave 
> it to the folks who actually know something about the feature, which 
> isn't me.

Ok, consider the x86 bits NAK-ed, which is lifted if the text is 
updated as well.

Thanks,

	Ingo
