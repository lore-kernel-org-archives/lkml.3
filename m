Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637Ab3FSKGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933830Ab3FSKG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:06:29 -0400
Message-ID: <51C18299.8010202@redhat.com>
Date: Wed, 19 Jun 2013 12:06:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexey Kardashevskiy <aik@ozlabs.ru>
CC: linux-doc@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Rob Landley <rob@landley.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm api doc: fix section numbers
References: <1371606127-1192-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1371606127-1192-1-git-send-email-aik@ozlabs.ru>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 03:42, Alexey Kardashevskiy ha scritto:
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  Documentation/virtual/kvm/api.txt |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 5f91eda..6365fef 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2261,7 +2261,7 @@ return indicates the attribute is implemented.  It does not necessarily
>  indicate that the attribute can be read or written in the device's
>  current state.  "addr" is ignored.
>  
> -4.77 KVM_ARM_VCPU_INIT
> +4.82 KVM_ARM_VCPU_INIT
>  
>  Capability: basic
>  Architectures: arm
> @@ -2285,7 +2285,7 @@ Possible features:
>  	  Depends on KVM_CAP_ARM_PSCI.
>  
>  
> -4.78 KVM_GET_REG_LIST
> +4.83 KVM_GET_REG_LIST
>  
>  Capability: basic
>  Architectures: arm
> @@ -2305,7 +2305,7 @@ This ioctl returns the guest registers that are supported for the
>  KVM_GET_ONE_REG/KVM_SET_ONE_REG calls.
>  
>  
> -4.80 KVM_ARM_SET_DEVICE_ADDR
> +4.84 KVM_ARM_SET_DEVICE_ADDR
>  
>  Capability: KVM_CAP_ARM_SET_DEVICE_ADDR
>  Architectures: arm
> @@ -2342,7 +2342,7 @@ and distributor interface, the ioctl must be called after calling
>  KVM_CREATE_IRQCHIP, but before calling KVM_RUN on any of the VCPUs.  Calling
>  this ioctl twice for any of the base addresses will return -EEXIST.
>  
> -4.82 KVM_PPC_RTAS_DEFINE_TOKEN
> +4.85 KVM_PPC_RTAS_DEFINE_TOKEN
>  
>  Capability: KVM_CAP_PPC_RTAS
>  Architectures: ppc
> 

Applied to next, thanks.

Paolo
