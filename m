Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaLHKQC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:16:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53650 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbaLHKP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:15:59 -0500
Date: Mon, 8 Dec 2014 10:15:57 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
	manage its own MCLK
Message-ID: <20141208101557.GE14516@opensource.wolfsonmicro.com>
References: <1417696879-15402-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417696879-15402-1-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 08:41:19PM +0800, Zidan Wang wrote:
> When we want to use wm8960 codec, we should enable its MCLK in machine
> driver. It's reasonable for wm8960 codec driver to manage its own MCLK to
> save power.
> 
> If platform data is not supplied, we will get MCLK from device tree and check
> the return code to handle probe deferral.
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
