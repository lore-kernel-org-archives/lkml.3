Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaENRsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:48:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:23918 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaENRsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:48:02 -0400
X-CheckPoint: {5373AB24-20001-2100090A-1FFFF}
Message-ID: <5373AC51.8070400@tilera.com>
Date: Wed, 14 May 2014 13:48:01 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 15/32] tile: Implement irq_alloc/free_hwirq() for migration
References: <20140507153622.703412101@linutronix.de> <20140507154336.947853241@linutronix.de>
In-Reply-To: <20140507154336.947853241@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending since my mailer "helpfully" upgraded the previous version to multipart/mixed.)

On 5/7/2014 11:44 AM, Thomas Gleixner wrote:
> We want to convert the drivers over to the new interface and finally
> tile to sparse irqs. Implement irq_alloc/free_hwirq() for step by step
> migration.
>
>
> +void irq_free_hwirq(unsigned int irq)
> +{
> +	destroy_irq();
> +}

Should be destroy_irq(irq).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

