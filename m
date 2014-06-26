Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaFZHiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:38:04 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58378 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbaFZHiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140625182349.32686.25931@quantum>
References: <1403713591-17179-1-git-send-email-pdeschrijver@nvidia.com>
 <44039675.8s16pHQIVH@wuerfel> <20140625182349.32686.25931@quantum>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 26 Jun 2014 09:37:40 +0200
X-Google-Sender-Auth: lEzY2uMxTgbMeGPCDNO0XGM2CPU
Message-ID: <CAAObsKDVrXRgO1e2=SorGiNUMhGPCCUUPtsjDfnST9gFN4=qTQ@mail.gmail.com>
Subject: Re: [PATCH] clk: define and export __clk_get_debug for providers
To: Mike Turquette <mturquette@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2014 20:23, Mike Turquette <mturquette@linaro.org> wrote:
>
> Peter,
>
> Just FYI, I'm trying to reverse the trend of prepending double
> underscores for functions that are used by clock providers. That stuff
> started out small and sort of grew out of control ;-)

I'm looking at rebasing Rabin's patches for per-user clks, and I have
had to add a few variants for providers, so they can be called with
clk_core instead. Have been prepending underscores for those internal
variants, but in some cases I had to also append a _internal suffix
because there were already variants without locking.

What convention were you thinking of for distinguishing provider-only
variants for e.g. clk_set_rate?

Regards,

Tomeu
