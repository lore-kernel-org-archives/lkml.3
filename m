Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaBLKk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:40:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52354 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaBLKkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:40:23 -0500
Date: Wed, 12 Feb 2014 11:40:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140212104017.GA5121@pd.tnic>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140212103713.GE3545@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:37:13AM +0100, Peter Zijlstra wrote:
> > Another reporter also saw this on an AMD and said it could not be reproduced on
> > the same hardware and the same software versions when using 64bit instead of 32.
> > 
> > In my case on a 32bit installation I will see this on every invocation of
> 
> Curious.. so its both AMD and Intel.
> 
> That makes funny hardware less likely... but how can the vmexit loose an
> interrupt like this.

Also what I'm wondering about and what's not clear from Stefan's reply
is whether this is purely a 32-bit issue, i.e. a 32-bit host running a
64-bit qemu running a 32-bit iso or what is it?

Or do we have reports for both 32-bit and 64-bit hosts?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
