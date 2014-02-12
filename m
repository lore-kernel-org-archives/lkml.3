Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaBLLML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:12:11 -0500
Received: from 8bytes.org ([85.214.48.195]:57847 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaBLLMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:12:10 -0500
Date: Wed, 12 Feb 2014 12:12:05 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stefan Bader <stefan.bader@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>
Subject: Re: Another preempt folding issue?
Message-ID: <20140212111205.GE23709@8bytes.org>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212104017.GA5121@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb 12 12:12:07 2014
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52fb570720861005615564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 11:40:17AM +0100, Borislav Petkov wrote:
> Also what I'm wondering about and what's not clear from Stefan's reply
> is whether this is purely a 32-bit issue, i.e. a 32-bit host running a
> 64-bit qemu running a 32-bit iso or what is it?
> 
> Or do we have reports for both 32-bit and 64-bit hosts?

As I  understand it, the problem reproduces only on a 32bit host, which
also limits the guests to 32bit, at least when ran with KVM. This is
true even if a x86-64 qemu is used. This is also independent on whether
the host-cpu supports 64bit or not.


	Joerg


