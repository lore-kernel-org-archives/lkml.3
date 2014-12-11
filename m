Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaLKJPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:15:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60436 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbaLKJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:15:12 -0500
Date: Thu, 11 Dec 2014 09:15:09 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
	manage its own MCLK
Message-ID: <20141211091508.GG14516@opensource.wolfsonmicro.com>
References: <1418103916-31295-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418103916-31295-1-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2014 at 01:45:16PM +0800, Zidan Wang wrote:
> When we want to use wm8960 codec, we should enable its MCLK in machine
> driver. It's reasonable for wm8960 codec driver to manage its own MCLK to
> save power.
> 
> Enable runtime power management, and auto enable/disable MCLK in pm_runtime
> resume and suspend. When wm8960 codec is being used, it will triger resume()
> to enable MCLK. When codec is not being used, it will triger suspend() to
> disable MCLK.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
