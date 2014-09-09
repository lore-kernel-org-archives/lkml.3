Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbaIISAP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:00:15 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:54764 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaIISAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:00:13 -0400
MIME-Version: 1.0
In-Reply-To: <f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
References: <cover.1410276224.git.marcel@ziswiler.com>
	<f90791ebb1799a4aa62dd6b527885ddadae3c058.1410276224.git.marcel@ziswiler.com>
Date: Tue, 9 Sep 2014 15:00:11 -0300
Message-ID: <CAOMZO5BYGwHGSeHeaQxEO=BUBGbno9P29et582SDzmwmfVioZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ASoC: tegra: add tegra sgtl5000 machine driver
From: Fabio Estevam <festevam@gmail.com>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        stefan@agner.ch
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 12:28 PM, Marcel Ziswiler <marcel@ziswiler.com> wrote:
> This binding and driver describe/support playback to headphones, and
> capture from line-in and microphone.
>
> This driver is useful for the Toradex Apalis T30 and Colibri T30 modules.
>
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> ---
>  .../bindings/sound/nvidia,tegra-audio-sgtl5000.txt |  45 +++++
>  sound/soc/tegra/Kconfig                            |  10 +
>  sound/soc/tegra/Makefile                           |   2 +
>  sound/soc/tegra/tegra_sgtl5000.c                   | 216 +++++++++++++++++++++

What about using the simple-audio-card binding instead of adding the
tegra_sgtl5000 machine driver?

An example of simple-audio-card used with sgtl5000 can be found here:

http://www.spinics.net/lists/devicetree/msg44466.html
