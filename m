Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaCDIZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:25:23 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50147 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbaCDIZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:25:21 -0500
Date: Tue, 4 Mar 2014 16:25:12 +0800
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V3 4/5] mfd: palmas: support IRQ inversion at the board
 level
Message-ID: <20140304082512.GF10579@lee--X1>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
 <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stephen Warren <swarren@nvidia.com>
> 
> Implement the new DT property ti,irq-externally-inverted, and add an
> equivalent platform data field to match. This allows the driver to
> correctly automatically configure the IRQ output polarity when the board
> or SoC contains an inverter between the Palmas IRQ output and IRQ
> controller input.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> v3:
> * Use an IRQD flag to represent the data, rather than a custom DT property.
> v2:
> * Split V1's patch 1/2 into separate patches 1/3 and 2/3.
> ---
>  drivers/mfd/palmas.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Looks good to me. Let me know how you want to deal with this. I'm
happy to create an immutable branch for everyone to pull from.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
