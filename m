Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JBVHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:07:52 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:36337 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3JBVHu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:07:50 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
Date: Wed, 2 Oct 2013 14:07:49 -0700
Message-ID: <CAOesGMijLSoKz9DTmSLr3YY-8=NoB97brhC-rSPj1x8zs1NXKQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add some missing bits for exynos5250-snow
From: Olof Johansson <olof@lixom.net>
To: Sean Paul <seanpaul@chromium.org>
Cc: dri-devel@lists.freedesktop.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Inki Dae <inki.dae@samsung.com>, airlied@linux.ie
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Oct 1, 2013 at 4:40 PM, Sean Paul <seanpaul@chromium.org> wrote:
> This set adds some missing devicetree nodes to the exynos5250-snow file as well
> as adds a drm_bridge driver for the ptn3460 DP-LVDS chip. This chip is used in
> the exynos5250-snow board.
>
> Sean
>
>
> Sean Paul (5):
>  ARM: dts: Add fimd display-timings for exynos5250-snow
>  ARM: dts: Add dp-controller node to exynos5250-snow
>  drm/bridge: Add PTN3460 bridge driver
>  drm/exynos: Initialize ptn3460 if present
>  ARM: dts: Add ptn3460 to exynos5250-snow
>
> Documentation/devicetree/bindings/drm/bridge/ptn3460.txt |  27 +++++++++++++++++++++++++
> arch/arm/boot/dts/exynos5250-snow.dts                    |  48 ++++++++++++++++++++++++++++++++++++++++++++

This should go in through Kukjin and the arm-soc tree, not through DRM
(Looking at the actual patch shortly).

> drivers/gpu/drm/Kconfig                                  |   2 ++
> drivers/gpu/drm/Makefile                                 |   1 +
> drivers/gpu/drm/bridge/Kconfig                           |   4 ++++
> drivers/gpu/drm/bridge/Makefile                          |   3 +++
> drivers/gpu/drm/bridge/ptn3460.c                         | 349 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Tip: When you generate the diffstat, redirect to a file or size your
window to something less than, oh, 300 characters wide or so. Maybe
even down to 80. :)


-Olof
