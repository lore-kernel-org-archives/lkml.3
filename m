Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3JAG5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 02:57:33 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45239 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3JAG5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 02:57:31 -0400
Date: Tue, 1 Oct 2013 08:57:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] nohz: Drop generic vtime obsolete dependency on
 CONFIG_64BIT
Message-ID: <20131001065728.GB19718@gmail.com>
References: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
 <1380550012-7321-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380550012-7321-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

>  config VIRT_CPU_ACCOUNTING_GEN
>  	bool "Full dynticks CPU time accounting"
> -	depends on HAVE_CONTEXT_TRACKING && 64BIT
> +	depends on HAVE_CONTEXT_TRACKING
>  	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
>  	select VIRT_CPU_ACCOUNTING
>  	select CONTEXT_TRACKING

> @@ -100,7 +100,6 @@ config NO_HZ_FULL
>  	# RCU_USER_QS dependency
>  	depends on HAVE_CONTEXT_TRACKING
>  	# VIRT_CPU_ACCOUNTING_GEN dependency
> -	depends on 64BIT
>  	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN

Yay!

Thanks,

	Ingo
