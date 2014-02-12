Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaBLLyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:54:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35462 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaBLLyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:54:46 -0500
Date: Wed, 12 Feb 2014 12:54:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
Message-ID: <20140212115412.GW27965@twins.programming.kicks-ass.net>
References: <52FA6D4B.7020709@canonical.com>
 <20140211194553.GZ9987@twins.programming.kicks-ass.net>
 <52FB2EC8.4080602@canonical.com>
 <20140212103713.GE3545@laptop.programming.kicks-ass.net>
 <20140212104017.GA5121@pd.tnic>
 <52FB5669.7090506@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FB5669.7090506@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 12:09:29PM +0100, Stefan Bader wrote:
> Something else here I run a kernel with CONFIG_PREEMPT not set and NR_CPUS
> limited to 8 (for the 32bit kernel). So the default apic driver is used. Since
> default_send_IPI_mask_logical is only used from there, I assume the trace you
> got does the same. Maybe something there is wrong which would explain why we
> only see it on 32bit hosts.

Can you try with a different APIC driver to test this?
