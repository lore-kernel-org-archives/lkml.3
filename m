Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaDQU6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:58:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38535 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaDQU6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:58:04 -0400
Message-ID: <53504041.7090906@ti.com>
Date: Thu, 17 Apr 2014 16:57:37 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH V2 00/19] bus: omap_l3_noc: driver cleanups and support
 for DRA7/AM4372
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com>
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishant,

On Thursday 17 April 2014 04:49 PM, Nishanth Menon wrote:
> The following V2 of the series is based on v3.15-rc1 + peter's patch series:
> 	patch #1: https://patchwork.kernel.org/patch/3923141/
> 	(drivers: bus: omap_l3: Convert to use devm_kzalloc)
> 
> 	patch #2: https://patchwork.kernel.org/patch/3923061/
> 	(drivers: bus: omap_l3: Convert to use devm_ioremap_resource() )
> 
> 	patch #3: https://patchwork.kernel.org/patch/3923101/
> 	(drivers: bus: omap_l3: Convert to use devm_request_irq())
> 
> 	patch #4: https://patchwork.kernel.org/patch/3923081/
> 	(drivers: bus: omap_l3: Remove the platform driver's remove function)
> 
> 	patch #5: https://patchwork.kernel.org/patch/3923121/
> 	(drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request
> 	fails)
> 
> V1 was originally posted here: http://marc.info/?l=linux-omap&m=139749383932575&w=2
> 
> V2 introduces the following changes:
> 	- Additional bug fix detected during additional testing (all tests complete now). patch #12
> 	- reordering of patches to order logical changes and reduce code churn.
> 	- interrupt handler split up and additional information now provided in log to aid debug when error occur
> 	- patches are marked where new (12,14,15,16).
> 	- DRA7 updated from master document for all DRA7 variants.
> 
> This series cleansup omap_l3_noc driver and adds data to support DRA7
> and AM437x SoCs.
> 
I looked at the series and its looks pretty good. Thanks for fixups, updates.
For whole series,
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

> Patches(including Peter's) is available here:
> https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v2
> 
Can Tony pull this branch for 3.16 then which includes Peter's series as well ?

Tony, Will you be able to line these up via arm-soc tree ?

Regards,
Santosh

