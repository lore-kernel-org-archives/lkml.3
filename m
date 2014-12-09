Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaLIFeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 00:34:03 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60609 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaLIFeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 00:34:00 -0500
MIME-Version: 1.0
In-Reply-To: <1417709696-29281-4-git-send-email-tomeu.vizoso@collabora.com>
References: <1417709696-29281-1-git-send-email-tomeu.vizoso@collabora.com> <1417709696-29281-4-git-send-email-tomeu.vizoso@collabora.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 9 Dec 2014 14:33:39 +0900
Message-ID: <CAAVeFu+UZyzF6c+MMnXFAKUbDcw6aan13Sg88c9-YbUsbXYKnw@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ARM: tegra: Add Tegra124 ACTMON support
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 1:14 AM, Tomeu Vizoso <tomeu.vizoso@collabora.com> wrote:
> Add device node for the ACTMON block to the Tegra124 device tree.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>
> ---
>
> v3:     * Address misc. style issues found by Thierry and Alexander
>         * Added helpers for register i/o
>         * Further documented the structs
>         * Enable the ACTMON after the IRQ handler has been installed
>         * Disable the ACTMON before removing the IRQ handler
>         * Add governor in a subsys initcall
>
> v2:     * Add operating-points property
> ---
>  arch/arm/boot/dts/tegra124.dtsi        |  23 +
>  drivers/devfreq/Kconfig                |   7 +-
>  drivers/devfreq/Makefile               |   2 +-
>  drivers/devfreq/tegra-actmon-devfreq.c | 777 +++++++++++++++++++++++++++++++++
>  drivers/devfreq/tegra-devfreq.c        | 718 ------------------------------

In patch 2/3 you create tegra-devfreq.c, to apparently move it to
tegra-actmon-devfreq.c and (seemingly) add somemore lines to it. This
makes things difficult to review, and I am almost sure this is a
naming mistake - could you fix this and resend?
