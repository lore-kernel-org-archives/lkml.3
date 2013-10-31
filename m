Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3JaIc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607Ab3JaIc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:32:56 -0400
Date: Thu, 31 Oct 2013 10:32:47 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, agraf@suse.de, chao.zhou@intel.com,
        magnus@boden.cx, kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM_SET_XCRS fixes
Message-ID: <20131031083247.GP4651@redhat.com>
References: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382021447-20216-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 04:50:45PM +0200, Paolo Bonzini wrote:
> The first patch fixes bugs 63121 and 63131 (yeah, all kernel bugs
> end with 1).  The second patch fixes a typo (the same typo exists
> in QEMU).
> 
> Paolo Bonzini (2):
>   KVM: x86: fix KVM_SET_XCRS for CPUs that do not support XSAVE
>   KVM: x86: fix KVM_SET_XCRS loop
> 
>  arch/x86/kvm/x86.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
Reviewed-by: Gleb Natapov <gleb@redhat.com>

--
			Gleb.
