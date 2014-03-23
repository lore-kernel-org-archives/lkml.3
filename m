Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaCWEHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 00:07:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:43219 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaCWEG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 00:06:57 -0400
Message-ID: <1395543886.3460.95.camel@pasglop>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
Date: Sun, 23 Mar 2014 14:04:46 +1100
In-Reply-To: <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
	 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1594945..8122294 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -82,6 +82,7 @@ config ARM
>  	  <http://www.arm.linux.org.uk/>.
>  
>  config ARM_HAS_SG_CHAIN
> +	select ARCH_HAS_SG_CHAIN
>  	bool
>  

Heh, a self-selecting config option... I didn't know that trick !

Ben.


