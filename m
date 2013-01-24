Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3AXKTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:19:03 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:34674 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3AXKTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:19:00 -0500
Date: Thu, 24 Jan 2013 11:18:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@redhat.com
Subject: Re: [PATCH] CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL
Message-ID: <20130124101854.GC27602@gmail.com>
References: <20130122192102.GE6538@redacted.bos.redhat.com>
 <20130123140440.8a4b1e3f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123140440.8a4b1e3f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 22 Jan 2013 14:21:03 -0500
> Kyle McMartin <kyle@redhat.com> wrote:
> 
> > CONFIG_EXPERT is a bit silly a place for this, and hides it
> > unnecessarily. CONFIG_DEBUG_KERNEL makes much more sense.
> > 
> > Signed-off-by: Kyle McMartin <kyle@redhat.com>
> > 
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -243,7 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
> >  	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
> >  
> >  config PANIC_ON_OOPS
> > -	bool "Panic on Oops" if EXPERT
> > +	bool "Panic on Oops" if DEBUG_KERNEL
> >  	default n
> >  	help
> >  	  Say Y here to enable the kernel to panic when it oopses. This
> 
> hm, I'm not sure that it should depend on anything.  Where's the benefit?

Agreed.

(The 'default n' is superfuous as well, while at it.)

Thanks,

	Ingo
