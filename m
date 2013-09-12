Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab3ILKD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 06:03:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40121 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3ILKD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 06:03:27 -0400
Message-ID: <5231903F.7080301@ti.com>
Date: Thu, 12 Sep 2013 15:28:23 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Matt Porter <matt@ohporter.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Russell King <linux@arm.linux.org.uk>,
        Jyri Sarah <jsarha@ti.com>, Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1378839171-14455-1-git-send-email-joelf@ti.com>
In-Reply-To: <1378839171-14455-1-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 September 2013 12:22 AM, Joel Fernandes wrote:
> HWMOD removal for MMC is breaking edma_start as the events are being manually
> triggered due to unused channel list not being clear.
> 
> This patch fixes the issue, by reading the "dmas" property from the DT node if
> it exists and clearing the bits in the unused channel list. For this purpose
> we use the of_* helpers to parse the arguments in the dmas phandle list.
> 
> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
> Reported-by: Balaji T K <balajitk@ti.com>
> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
> This patch is a repost of v2 with minor change of return value.

Is this patch meant for merging? If yes, I see no resolution of the
comments given in this thread:

https://lkml.org/lkml/2013/7/30/9

It is better to send one version with all comments fixed. Helps avoid
confusion.

Thanks,
Sekhar

