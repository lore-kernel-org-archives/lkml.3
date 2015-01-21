Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbbAUKVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbbAUKVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:21:44 -0500
Message-ID: <54BF7D92.6020409@redhat.com>
Date: Wed, 21 Jan 2015 11:21:06 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 1/5] KVM: nVMX: Make nested control MSRs per-cpu.
References: <CACzj_yVKUUvbke3XG7cHCQD7hr8fPsRbH1k_3V8L25M3-Y6sNQ@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC262EB@SHSMSX104.ccr.corp.intel.com> <CACzj_yW056JWb_+SbdQpfRfqJEUoWk4bRmGjnDOm18UgEzHwYA@mail.gmail.com>
In-Reply-To: <CACzj_yW056JWb_+SbdQpfRfqJEUoWk4bRmGjnDOm18UgEzHwYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/01/2015 10:23, Wincy Van wrote:
> Yes, moving that msrs looks a bit ugly, but the irqchip_in_kernel is
> per-VM, not a global
> setting, there would be different settings of kernel_irqchip between VMs.
> If we use irqchip_in_kernel to check it and set different value of the
> ctl msrs, I think it may
> be even worse than moving the msrs, because this logic should be a
> init function, and this
> setting should be converged.

I too prefer your solution.

Paolo
