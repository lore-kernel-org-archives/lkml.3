Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3LRRxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:53:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3LRRxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:53:23 -0500
Date: Wed, 18 Dec 2013 09:53:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, francis.moro@gmail.com, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH backport hints for <3.10] KVM: x86: Convert vapic
 synchronization to _cached functions (CVE-2013-6368)
Message-ID: <20131218175324.GA368@kroah.com>
References: <1387193897-24658-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387193897-24658-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 12:38:17PM +0100, Paolo Bonzini wrote:
> The KVM patch "fix vapic memory corruption" applies to most kernels that
> have KVM, but the fix does not apply on many older branches.  The APIs it
> uses are available in 3.1, but until 3.9 kvm_gfn_to_hva_cache_init had
> one fewer parameter.
> 
> The comments in this patch should help fixing kvm_lapic_set_vapic_addr
> in older kernels.  I will review the backports as they are posted to
> LKML (if I am CCed...).

This fails to build on 3.4-stable, could you provide a working backport
for that kernel?

thanks,

greg k-h
