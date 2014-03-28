Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbaC1CtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 22:49:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:54032 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757010AbaC1CtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 22:49:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,747,1389772800"; 
   d="scan'208";a="481858325"
Date: Fri, 28 Mar 2014 10:48:13 +0800
From: Feng Tang <feng.tang@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Clemens Ladisch <clemens@ladisch.de>, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: hpet: Don't default CONFIG_HPET_TIMER to be y for
 X86_64
Message-ID: <20140328024813.GB31111@feng-snb>
References: <1395906309-7519-1-git-send-email-feng.tang@intel.com>
 <53340561.4050708@ladisch.de>
 <53348199.7070207@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53348199.7070207@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 12:52:57PM -0700, Andy Lutomirski wrote:
> On 03/27/2014 04:02 AM, Clemens Ladisch wrote:
> > Feng Tang wrote:
> >> On many new phone/tablet platforms like Baytrail/Merrifield etc,
> >> the HPET are either defeatured or has some problem to be used
> >> as a reliable timer. As these platforms also have X86_64, we
> >> should not make HPET_TIMER default y for all X86_64.
> 
> Wouldn't it be better to fix the hpet driver so that the hpet doesn't
> used on these platforms?
> 
> > 
> > The help text still says:
> > | You can safely choose Y here.  [...]
> > | Choose N to continue using the legacy 8254 timer.
> > 
> > Are these statements still true for those platforms?
> 
> They aren't true for modern desktop and server platforms -- the TSC is
> used regardless of hpet availability.

The way of using TSC varies depends on the generations of platforms.
Thomas Gleixner once gave a very good description, which link I personally
bookmarked, and would share here:
	https://lkml.org/lkml/2013/5/8/202

Thanks,
Feng

