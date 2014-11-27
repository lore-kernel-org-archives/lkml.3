Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaK0KTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:19:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33230 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbaK0KTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:19:14 -0500
Date: Thu, 27 Nov 2014 10:19:11 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Zidan Wang <b50113@freescale.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        lars@metafoo.de, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH] ASoC: wm8960: Move register initialisation
	to I2C driver probe()
Message-ID: <20141127101911.GB13764@opensource.wolfsonmicro.com>
References: <1417078388-1289-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417078388-1289-1-git-send-email-b50113@freescale.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 04:53:08PM +0800, Zidan Wang wrote:
> We must ensure that the clocking configuration is valid as rapidly as possible.
> And do software reset before the others registers updates, or the registers
> will be reset to the default state.
> 
> Signed-off-by: Zidan Wang <b50113@freescale.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Looks ok to me.

Thanks,
Charles
