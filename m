Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbaLDSFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:05:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbaLDSFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:05:37 -0500
Date: Thu, 4 Dec 2014 19:05:33 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH 8/9] kvm: vmx: add MSR logic for XSAVES
Message-ID: <20141204180532.GC18651@potion.brq.redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-9-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-9-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-04 16:57+0100, Paolo Bonzini:
> From: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> Add logic to get/set the XSS model-specific register.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> @@ -2896,7 +2919,8 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
>  			SECONDARY_EXEC_ENABLE_INVPCID |
>  			SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
> -			SECONDARY_EXEC_SHADOW_VMCS;
> +			SECONDARY_EXEC_SHADOW_VMCS |
> +			SECONDARY_EXEC_XSAVES;

(Nothing to see here, move along ...)
