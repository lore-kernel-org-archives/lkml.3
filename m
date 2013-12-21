Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3LURUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 12:20:00 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:56919 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3LURT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 12:19:58 -0500
Date: Sat, 21 Dec 2013 17:19:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/10] ASoC: ARM: ux500: Better prepare for full Device
 Tree
Message-ID: <20131221171953.GA7988@lee--X1>
References: <1387468508-12286-1-git-send-email-lee.jones@linaro.org>
 <20131221142959.GH30815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131221142959.GH30815@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > At this moment in time the Ux500 ASoC driver obtains its DMA information
> > via AUXDATA platform data passing. To make the driver more independent
> > we have to start extracting it from the Device Tree. This patch-set goes
> > some way to ensure the ux500 Audio driver is ready for the switch over.
> 
> This all looks good to me, I guess it's OK if I merge the ARM patch?

That would be up to Linus.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
