Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3KFOMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127Ab3KFOMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:12:36 -0500
Date: Wed, 6 Nov 2013 09:12:21 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, prarit@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 1/2 v2] x86: Allow higher NR_CPUS values
Message-ID: <20131106141221.GN9944@hansolo.jdub.homelinux.org>
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org>
 <20131105143728.GJ9944@hansolo.jdub.homelinux.org>
 <20131106071540.GA3053@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106071540.GA3053@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 08:15:40AM +0100, Ingo Molnar wrote:
> 
> * Josh Boyer <jwboyer@redhat.com> wrote:
> 
> > diff --git a/lib/Kconfig b/lib/Kconfig
> > index b3c8be0..0ea738e 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -342,7 +342,7 @@ config CHECK_SIGNATURE
> >  	bool
> >  
> >  config CPUMASK_OFFSTACK
> > -	bool "Force CPU masks off stack" if DEBUG_PER_CPU_MAPS
> > +	bool "Force CPU masks off stack"
> 
> this aspect causes build failures with the attached config.

Bother.  OK, I'll poke at it today.  You wouldn't happen to have a
pointer to the build failure, would you?

josh
