Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbaFXAMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:12:15 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:52386 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaFXAMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:12:13 -0400
MIME-Version: 1.0
In-Reply-To: <1403556805-22824-1-git-send-email-swarren@wwwdotorg.org>
References: <1403556805-22824-1-git-send-email-swarren@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 24 Jun 2014 09:11:52 +0900
Message-ID: <CAAVeFuJxb0vvfcebZtoQwYQzK7S03NR5OasK1mV11ZUBtt4c+g@mail.gmail.com>
Subject: Re: [PATCH] regulator: palmas: fix typo in enable_reg calculation
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Keerthy <j-keerthy@ti.com>,
        Nishanth Menon <nm@ti.com>, linux-omap@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 5:53 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> When setting up .enable_reg for an SMPS regulator, presumably we should
> call PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE, ...) rather than using
> LDO_BASE. This change makes the LCD panel and HDMI work again on the
> NVIDIA Dalmore board anyway.

Tested-by: Alexandre Courbot <acourbot@nvidia.com>

Interestingly the first fix was enough for Tegra Note 7's panel -
probably due to the fact the panel was already on when the kernel took
over.
