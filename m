Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3JaMkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab3JaMkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:40:14 -0400
Message-ID: <52724F99.3050908@redhat.com>
Date: Thu, 31 Oct 2013 13:39:53 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm_host: typo fix
References: <20131030194301.GA26143@redhat.com>
In-Reply-To: <20131030194301.GA26143@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/10/2013 20:43, Michael S. Tsirkin ha scritto:
> fix up typo in comment.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0fbbc7a..7445013 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -789,7 +789,7 @@ static inline void kvm_guest_enter(void)
>  
>  	/* KVM does not hold any references to rcu protected data when it
>  	 * switches CPU into a guest mode. In fact switching to a guest mode
> -	 * is very similar to exiting to userspase from rcu point of view. In
> +	 * is very similar to exiting to userspace from rcu point of view. In
>  	 * addition CPU may stay in a guest mode for quite a long time (up to
>  	 * one time slice). Lets treat guest mode as quiescent state, just like
>  	 * we do with user-mode execution.
> 

Applying this to kvm/queue, thanks.

Paolo
