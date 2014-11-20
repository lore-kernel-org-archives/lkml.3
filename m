Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaKTJMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:12:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45897 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbaKTJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:12:24 -0500
Date: Thu, 20 Nov 2014 09:12:20 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v2 2/2] ASoC: wm8960: LRCM operation should
	after software reset
Message-ID: <20141120091220.GG12443@opensource.wolfsonmicro.com>
References: <1416472878-12108-1-git-send-email-b50113@freescale.com> <1416472878-12108-2-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416472878-12108-2-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:41:18PM +0800, Zidan Wang wrote:
> When shared_lrclk is set, LRCM will be enabled. But the following software
> reset in wm8960_probe will reset it to the default state. So LRCM operation
> should after software reset.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---

For patch 2 here:

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Patch 1 could still use the docs fixups Lars suggested.

Thanks,
Charles
