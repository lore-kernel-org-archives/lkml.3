Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3EAVKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:10:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34116 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086Ab3EAVKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:10:14 -0400
Date: Wed, 1 May 2013 23:10:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130501211011.GD4466@pd.tnic>
References: <20130426095140.GA15361@pd.tnic>
 <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org>
 <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com>
 <20130501203500.GC4466@pd.tnic>
 <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 02:00:06PM -0700, David Rientjes wrote:
> With this applied, two other types of conflicting dependencies:
> 
> warning: (KVM_GUEST_COMMON_OPTIONS) selects VIRTIO_NET which has unmet direct dependencies (NETDEVICES && NET_CORE && VIRTIO)
> 
> and
> 
> warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)

How do you trigger those? I don't see them here with this applied.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
