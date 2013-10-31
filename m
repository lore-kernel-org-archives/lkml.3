Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3JaLJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab3JaLJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:09:46 -0400
Message-ID: <52723A75.9050709@redhat.com>
Date: Thu, 31 Oct 2013 12:09:41 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        KVM List <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] MAINTAINERS: add tree for kvm.git
References: <1383217163-14555-1-git-send-email-artagnon@gmail.com>
In-Reply-To: <1383217163-14555-1-git-send-email-artagnon@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2013 11:59, Ramkumar Ramachandra ha scritto:
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: KVM List <kvm@vger.kernel.org>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  This is a replacement for [PATCH 2/3] Documentation/kvm: patches
>  should be against linux.git
> 
>  Thanks to Paolo for pointing to the right tree.
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1dd73f7..36b05119 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4836,6 +4836,7 @@ M:	Gleb Natapov <gleb@redhat.com>
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  L:	kvm@vger.kernel.org
>  W:	http://www.linux-kvm.org
> +T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
>  S:	Supported
>  F:	Documentation/*/kvm*.txt
>  F:	Documentation/virtual/kvm/
> 

Looks like we crossed. :)  I'm applying this patch and the other 2 from
the first submission.  Thanks!

Paolo
