Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3AWWEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:04:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3AWWEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:04:42 -0500
Date: Wed, 23 Jan 2013 14:04:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle McMartin <kyle@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL
Message-Id: <20130123140440.8a4b1e3f.akpm@linux-foundation.org>
In-Reply-To: <20130122192102.GE6538@redacted.bos.redhat.com>
References: <20130122192102.GE6538@redacted.bos.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 14:21:03 -0500
Kyle McMartin <kyle@redhat.com> wrote:

> CONFIG_EXPERT is a bit silly a place for this, and hides it
> unnecessarily. CONFIG_DEBUG_KERNEL makes much more sense.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -243,7 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
>  	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
>  
>  config PANIC_ON_OOPS
> -	bool "Panic on Oops" if EXPERT
> +	bool "Panic on Oops" if DEBUG_KERNEL
>  	default n
>  	help
>  	  Say Y here to enable the kernel to panic when it oopses. This

hm, I'm not sure that it should depend on anything.  Where's the benefit?
