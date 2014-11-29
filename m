Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaK2Hav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 02:30:51 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60344 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaK2Hat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 02:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
References: <1417173180-21726-1-git-send-email-vinceh@nvidia.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 29 Nov 2014 16:30:28 +0900
Message-ID: <CAAVeFuLfqhN87fOxc9sd09rzd4jSLkLs21ZGS1aV8NTo_uwpkQ@mail.gmail.com>
Subject: Re: [RESEND V2 PATCH 1/3] soc/tegra: fuse: export tegra_sku_info for
 module use
To: Vince Hsu <vinceh@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 8:12 PM, Vince Hsu <vinceh@nvidia.com> wrote:
> Some Tegra drivers might be complied as kernel modules, and
> they need the fuse information for initialization. One
> example is the GK20A Nouveau driver. It needs the GPU speedo
> value to calculate frequency-voltage table. So export
> the tegra_sku_info.

Acked-by: Alexandre Courbot <acourbot@nvidia.com>

This is required for setting the optimal GPU voltage in Nouveau.
