Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaKGNTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:19:42 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63964 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbaKGNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:19:41 -0500
Message-ID: <1415366378.4390.48.camel@x220>
Subject: Re: [REGRESSION] in 3.18-rc1: ppp crashes kernel
From: Paul Bolle <pebolle@tiscali.nl>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 07 Nov 2014 14:19:38 +0100
In-Reply-To: <545CC0E8.4070102@message-id.googlemail.com>
References: <545CA8B6.2060608@message-id.googlemail.com>
	 <1415361193.4390.46.camel@x220>
	 <545CB37C.6080804@message-id.googlemail.com>
	 <545CC0E8.4070102@message-id.googlemail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Nov 2014 13:19:38.0074 (UTC) FILETIME=[7B2A5BA0:01CFFA8D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 13:54 +0100, Stefan Seyfried wrote:
> JFTR, this did not help:
> tux@linux:~/linux> zgrep CONFIG_RCU_NOCB_CPU /proc/config.gz
> # CONFIG_RCU_NOCB_CPU is not set
> 
> neither did:
> 
> --- a/init/main.c
> +++ b/init/main.c
> @@ -583,7 +583,7 @@ asmlinkage __visible void __init start_kernel(void)
>         early_irq_init();
>         init_IRQ();
>         tick_init();
> -       rcu_init_nohz();
> +//     rcu_init_nohz();
>         init_timers();
>         hrtimers_init();
>         softirq_init();

Thanks. I guess this is not my lucky day. I won't be visiting a casino
tonight...


Paul Bolle

