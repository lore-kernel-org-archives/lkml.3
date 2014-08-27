Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935735AbaH0Skk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:40:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57905 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933804AbaH0Skj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:40:39 -0400
Message-ID: <53FE260A.3080602@ti.com>
Date: Wed, 27 Aug 2014 14:40:10 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>
Subject: Re: [PATCH 0/6] ARM: OMAP3+: PRM: fix up prm_handling
References: <1408715513-25851-1-git-send-email-nm@ti.com>
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2014 09:51 AM, Nishanth Menon wrote:
> The following series are various fixes and improvements for
> PRM for I/O Daisy chain support in OMAP4+ with device tree.
> 
> This is part 2/6 series which eventually enables framework for
> suspend-to-ram and cpuidle for OMAP5 and DRA7
> 
> Each of series is based on v3.17-rc1 and this specific series is available:
> weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/prm-fixes
> 
>
Series also looks reasonable.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

