Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803Ab3HNMEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:04:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60660 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab3HNMEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:04:50 -0400
Message-ID: <520B723D.5020400@ti.com>
Date: Wed, 14 Aug 2013 17:34:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH v3 1/6] ARM: davinci: da8xx: fix clock lookup for mdio
 device
References: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com> <1371999607-6483-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1371999607-6483-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On 6/23/2013 8:30 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch removes the clock alias for mdio device and adds a entry
> in clock lookup table, this entry can now be used by both DT and NON
> DT case.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: netdev@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Heiko Schocher <hs@denx.de>

This patch looks good, except you can do the same thing on all DaVinci
devices not just on DA8XX. Apart from this patches 1-5 in this series
look good. If you can spin this fix in short time I can queue 1-5 for
v3.12 while we wait for you to fix 6/6

Thanks,
Sekhar
