Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaLENcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:32:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbaLENcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:32:31 -0500
Date: Fri, 5 Dec 2014 14:32:27 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH 4/9] kvm: x86: Add kvm_x86_ops hook that enables XSAVES
 for guest
Message-ID: <20141205133226.GB18653@potion.brq.redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
 <1417708634-24333-5-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417708634-24333-5-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I somehow managed to review one patch twice instead of this one ...)

2014-12-04 16:57+0100, Paolo Bonzini:
> From: Wanpeng Li <wanpeng.li@linux.intel.com>
> 
> Expose the XSAVES feature to the guest if the kvm_x86_ops say it is
> available.
> 
> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -69,6 +69,7 @@
>  #define SECONDARY_EXEC_PAUSE_LOOP_EXITING	0x00000400
>  #define SECONDARY_EXEC_ENABLE_INVPCID		0x00001000
>  #define SECONDARY_EXEC_SHADOW_VMCS              0x00004000
> +#define SECONDARY_EXEC_XSAVES			0x00100000

(Email exposes tab alignment nicely.)
