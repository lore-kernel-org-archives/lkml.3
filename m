Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab3KFLrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:47:22 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44673 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3KFLrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:47:21 -0500
MIME-Version: 1.0
In-Reply-To: <1383732985-18928-10-git-send-email-lee.jones@linaro.org>
References: <1383732985-18928-1-git-send-email-lee.jones@linaro.org>
	<1383732985-18928-10-git-send-email-lee.jones@linaro.org>
Date: Wed, 6 Nov 2013 12:47:20 +0100
Message-ID: <CACRpkdYCipiPM0YcosXV7t57LWnpeHRs=95bAs-v=wc-QRs00g@mail.gmail.com>
Subject: Re: [PATCH 09/13] ASoC: Ux500: Match platform by device node when
 booting Device Tree
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 11:16 AM, Lee Jones <lee.jones@linaro.org> wrote:

> We're getting closer to fully enabling the Ux500 ASoC driver for Device
> Tree. When we switch over from using AUXDATA we'll need to match platform
> by only Device Tree nodes. In this patch we NULL out the platform_name,
> and supply nodes for each platform device.
>
> Cc: alsa-devel@alsa-project.org
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
