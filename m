Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3EPP35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:29:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411Ab3EPP3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:29:54 -0400
Date: Thu, 16 May 2013 12:29:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: take over co-maintainership from Marcelo, fix
 MAINTAINERS entry
Message-ID: <20130516152937.GA18134@amt.cnet>
References: <1368637344-3354-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368637344-3354-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 07:02:24PM +0200, Paolo Bonzini wrote:
> As announced last week by Marcelo Tosatti, I will be co-maintaining
> KVM together with Gleb.
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d7782b..340cb64 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4641,12 +4641,13 @@ F:	include/linux/sunrpc/
>  F:	include/uapi/linux/sunrpc/
>  
>  KERNEL VIRTUAL MACHINE (KVM)
> -M:	Marcelo Tosatti <mtosatti@redhat.com>
>  M:	Gleb Natapov <gleb@redhat.com>
> +M:	Paolo Bonzini <pbonzini@redhat.com>
>  L:	kvm@vger.kernel.org
> -W:	http://kvm.qumranet.com
> +W:	http://linux-kvm.org
>  S:	Supported
> -F:	Documentation/*/kvm.txt
> +F:	Documentation/*/kvm*.txt
> +F:	Documentation/virtual/kvm/
>  F:	arch/*/kvm/
>  F:	arch/*/include/asm/kvm*
>  F:	include/linux/kvm*
> -- 
> 1.8.1.4

ACK

