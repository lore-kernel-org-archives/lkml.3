Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab3FLJvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:51:35 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:61860 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3FLJve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:51:34 -0400
MIME-Version: 1.0
In-Reply-To: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
References: <1371023879-21884-1-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 12 Jun 2013 11:51:33 +0200
Message-ID: <CACRpkdYpDoMCikZyQhDgnZA7QgvrTirBAKamaxBpNoT+8m=+yA@mail.gmail.com>
Subject: Re: [PATCH 0/3] DMA fixes for ux500 ASoC driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 9:57 AM, Fabio Baltieri
<fabio.baltieri@linaro.org> wrote:

> The DMA driver used on ux500 has been recently reworked to make it
> device-tree capable, but the rework required to drop some "features",
> such as opportunistic channel allocation and hardcoded addresses, that
> the ASoC driver was relying upon.
>
> This series fixes the audio driver to make it work with the current
> dma40 implementation, and works fine even when booting with device-tree.

FWIW: all look good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
