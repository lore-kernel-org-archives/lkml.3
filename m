Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaLCNEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:04:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41029 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaLCNEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:04:48 -0500
Message-ID: <547F0A57.7040806@ti.com>
Date: Wed, 3 Dec 2014 07:04:23 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ravikumar Kattekola <rk@ti.com>, Tony Lindgren <tony@atomide.com>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/2] ARM: dts: dra7-evm: Regulator max voltage fixes
References: <1417608237-12258-1-git-send-email-rk@ti.com>
In-Reply-To: <1417608237-12258-1-git-send-email-rk@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 06:03 AM, Ravikumar Kattekola wrote:
> Hi,
> 
> This set does a minor fix and an update:
> 
>    - Fix a typo in the max voltage property of smps6 (vdd_gpu) regulator node added by
>      the patch : c56a831ca47e ("ARM: dts: DRA7: Add TPS659038 PMIC nodes")
> 
>    - Update max voltage property of smps7 (vdd_core) regulator node to align with the 
>      latest Data Manual
> 
> Regards,
> RK
> 
> Ravikumar Kattekola (2):
>   ARM: dts: dra7-evm: Fix typo in SMPS6 (VDD_GPU) max voltage
>   ARM: dts: dra7-evm: Update SMPS7 (VDD_CORE) max voltage to match DM
> 
>  arch/arm/boot/dts/dra7-evm.dts  |    4 ++--
>  arch/arm/boot/dts/dra72-evm.dts |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
These apply to

https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/log/?h=omap-for-v3.19/dt-v2

Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
