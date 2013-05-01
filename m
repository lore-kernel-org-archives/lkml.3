Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762315Ab3EAVae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:30:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54989 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762267Ab3EAVaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:30:08 -0400
Date: Wed, 1 May 2013 14:30:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <20130501211011.GD4466@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org> <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com> <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com>
 <20130501211011.GD4466@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Borislav Petkov wrote:

> > warning: (KVM_GUEST_COMMON_OPTIONS) selects VIRTIO_NET which has unmet direct dependencies (NETDEVICES && NET_CORE && VIRTIO)
> > 
> > and
> > 
> > warning: (KVM_GUEST_COMMON_OPTIONS && AMD_IOMMU) selects PCI_MSI which has unmet direct dependencies (PCI && ARCH_SUPPORTS_MSI)
> 
> How do you trigger those? I don't see them here with this applied.
> 

It's an allnoconfig with HYPERVISOR_GUEST, PARAVIRT, KVM_GUEST, and 
KVM_GUEST_COMMON_OPTIONS enabled.
