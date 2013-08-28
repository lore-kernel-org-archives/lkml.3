Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3H1GkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754372Ab3H1GkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:40:14 -0400
Date: Wed, 28 Aug 2013 09:40:09 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] Trivial KVM patches for 3.12
Message-ID: <20130828064009.GL22899@redhat.com>
References: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377610903-12356-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 03:41:40PM +0200, Paolo Bonzini wrote:
> Gleb,
> 
> these are fixups for the patches I sent on July 31.  It would
> be nice to have them for the next merge window.
> 
> Thanks,
> 
Applied, thanks.

> Paolo
> 
> Paolo Bonzini (3):
>   KVM: rename __kvm_io_bus_sort_cmp to kvm_io_bus_cmp
>   KVM: vmx: count exits to userspace during invalid guest emulation
>   KVM: x86: add comments where MMIO does not return to the emulator
> 
>  arch/x86/kvm/vmx.c  |  1 +
>  arch/x86/kvm/x86.c  |  7 +++++--
>  virt/kvm/kvm_main.c | 16 ++++++++--------
>  3 files changed, 14 insertions(+), 10 deletions(-)
> 
> -- 
> 1.8.3.1

--
			Gleb.
