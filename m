Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaENRoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:44:19 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23862 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaENRoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:44:18 -0400
X-CheckPoint: {5373AA44-2000B-2100090A-1FFFF}
Message-ID: <5373AB71.3030705@tilera.com>
Date: Wed, 14 May 2014 13:44:17 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation facility
References: <20140507153622.703412101@linutronix.de> <20140507154334.208629358@linutronix.de>
In-Reply-To: <20140507154334.208629358@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> --- tip.orig/kernel/irq/Kconfig
> +++ tip/kernel/irq/Kconfig
> @@ -17,6 +17,11 @@ config GENERIC_IRQ_SHOW
>   config GENERIC_IRQ_SHOW_LEVEL
>          bool
>   
> +# Facility to allocate an hardware interrupt. This is legacy support
> +# and should not be used in new code. Use irq domains instead.
> +config GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
> +       bool

"a hardware interrupt".

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

