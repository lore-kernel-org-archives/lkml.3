Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab3IBOJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:09:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40201 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758350Ab3IBOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:09:30 -0400
Message-ID: <52249BF3.6000705@ti.com>
Date: Mon, 2 Sep 2013 19:38:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Matt Porter <matt@ohporter.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Russell King <linux@arm.linux.org.uk>,
        Sricharan R <r.sricharan@ti.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Franklin Cooper <fcooper@ti.com>
Subject: Re: [PATCH v4 3/6] ARM: edma: Add function to manually trigger an
 EDMA channel
References: <1377817545-18015-1-git-send-email-joelf@ti.com> <1377817545-18015-4-git-send-email-joelf@ti.com>
In-Reply-To: <1377817545-18015-4-git-send-email-joelf@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/30/2013 4:35 AM, Joel Fernandes wrote:
> Manual trigger for events missed as a result of splitting a
> scatter gather list and DMA'ing it in batches. Add a helper
> function to trigger a channel incase any such events are missed.
> 
> Signed-off-by: Joel Fernandes <joelf@ti.com>

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
