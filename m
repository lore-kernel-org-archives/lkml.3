Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaBNPVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 10:21:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37791 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbaBNPVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 10:21:40 -0500
Date: Fri, 14 Feb 2014 16:21:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue? (maybe bisect)
Message-ID: <20140214152132.GD26356@pd.tnic>
References: <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
 <20140212115412.GW27965@twins.programming.kicks-ass.net>
 <52FCFA23.4060701@canonical.com>
 <20140213173852.GH6835@laptop.programming.kicks-ass.net>
 <52FD090C.7010408@canonical.com>
 <20140213182605.GC14089@laptop.programming.kicks-ass.net>
 <20140214133428.GB26356@pd.tnic>
 <52FE2709.3050505@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52FE2709.3050505@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and just in case this is relatively easy to reproduce and in case we
don't have any other idea, bisection might be another option. I'm not
saying you should do it right away - I'm just putting it on the table...

:-)

:-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
