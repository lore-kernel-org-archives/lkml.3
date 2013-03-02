Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab3CCJZh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:25:37 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39399 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3CCJW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:22:57 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3 0/7] spi: spi-fsl-spi: Make spi-fsl-spi usable in cpu mode outside of FSL SOC environments and add a grlib variant normally running on sparc
To: Andreas Larsson <andreas@gaisler.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
References: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
Date: Sat, 02 Mar 2013 21:57:22 +0000
Message-Id: <20130302215723.05FE93E2261@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013 16:52:20 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> Changes since v3:
> - Patches 1-7: Added Acked-by: Anton Vorontsov <anton@enomsg.org>
> - Patch 1: Small style tweak lining up function arguments properly
> - Patch 7: Changed a style issue with two variables declared on same line
> - Patch 7: Removed usage of cs_gpio_flags variable to apply cleanly to spi/next
> - Patch 7: Changed get_named_gpio "hole value" to -ENOENT => Requries
>   the "spi: Initialize cs_gpio and cs_gpios with ENOENT" patch for
>   TYPE_GRLIB support

Merged entire series for v3.10, thanks.

g.

