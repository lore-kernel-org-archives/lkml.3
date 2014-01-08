Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaAHMDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:03:55 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:57526 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaAHMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:03:52 -0500
MIME-Version: 1.0
In-Reply-To: <1389170756-22351-3-git-send-email-Guangyu.Chen@freescale.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
	<1389170756-22351-3-git-send-email-Guangyu.Chen@freescale.com>
Date: Wed, 8 Jan 2014 10:03:51 -0200
Message-ID: <CAOMZO5AY1RaxFUcO0r7=Db8Hp_U6oPHSDke0Y0thhEKi5OGCdQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dma: imx-sdma: Assign a default script number for ROM
 firmware cases
From: Fabio Estevam <festevam@gmail.com>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Fabio Estevam <fabio.estevam@freescale.com>, dmaengine@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 6:45 AM, Nicolin Chen <Guangyu.Chen@freescale.com> wrote:
> i.MX series have inner firmware in its ROM code: when SDMA isn't provided
> any firmware from Kernel or rootfs, the default inner ROM firmware will be
> activated. However the current driver doesn't assign any script number to
> this situation, and those platform running in this case would be broken.
>
> Thus this patch adds a default script number when no external firmware being
> loaded so that people would continue to be able to use basic scripts to run
> their platform without any firmware.
>
> Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>

Thanks, Nicolin.

This fixes audio playback without additional SDMA firmware:

Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
