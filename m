Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbaDWUr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 16:47:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbaDWUr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 16:47:56 -0400
Date: Wed, 23 Apr 2014 17:47:36 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Nadav Amit <namit@cs.technion.ac.il>
Cc: gleb@kernel.org, pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] KVM: x86: Fix KVM behavior that does not follow spec
Message-ID: <20140423204736.GA31715@amt.cnet>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 02:33:06AM +0300, Nadav Amit wrote:
> This series of patches fix various scenarios in which KVM behavior does not
> follow x86 specifications.  Each patch actually deals with a separate bug.
> These bugs can cause the guest to get stuck (i.e., make no progress), encounter
> spurious injected exceptions, or cause guest code to misbehave. As a result
> guest OS can potentially fail.
> 
> Thanks for reviewing the patches.
> 
> Nadav Amit (5):
>   KVM: x86: Fix wrong/stuck PMU when guest does not use PMI
>   KVM: x86: Fix CR3 reserved bits
>   KVM: x86: IN instruction emulation should ignore REP-prefix
>   KVM: x86: RSI/RDI/RCX are zero-extended when affected by string ops
>   KVM: x86: Processor mode may be determined incorrectly

Applied all except patch 4.


