Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaFPJGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:06:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42589 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551AbaFPJGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:06:52 -0400
Date: Mon, 16 Jun 2014 10:06:49 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Xiubo Li <Li.Xiubo@freescale.com>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: wm8985: Remove unused pointer in wm8985_remove()
Message-ID: <20140616090649.GC12074@opensource.wolfsonmicro.com>
References: <1402679968-5925-1-git-send-email-cengelma@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402679968-5925-1-git-send-email-cengelma@gmx.at>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 07:19:28PM +0200, Christian Engelmayer wrote:
> Commit a0b148b4 (ASoC: wm8985: Use devm_regulator_bulk_get()) removed the last
> user of pointer wm8985 to struct wm8985_priv. Thus remove it. Detected by
> Coverity CID 1222150.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
