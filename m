Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3FVLao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 07:30:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58354 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3FVLam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 07:30:42 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
Subject: Re: [PATCH v2 0/2] Clock update for EXYNOS4210-CPUFREQ driver
Date: Sat, 22 Jun 2013 13:30:41 +0200
Message-ID: <2659166.6PZqLSy6sR@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.6-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <20130621174453.20448.59791@quantum>
References: <1371725238-25437-1-git-send-email-tushar.behera@linaro.org> <20130621174453.20448.59791@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 of June 2013 10:44:53 Mike Turquette wrote:
> Quoting Tushar Behera (2013-06-20 03:47:16)
> 
> > cpufreq driver for EXYNOS4 based SoCs are not platform drivers, hence
> > we cannot currently pass the clock names through a device tree node.
> > Instead, we need to make them available through global alias.
> > 
> > The patches are based on next-20130618.
> > 
> > Patch 1 has not been modified.
> > Patch 2 has been updated to include EXYNOS4X12 releated clocks.

Looks fine to me.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

> Patch and changelogs look good to me now. Tomasz, any comments? I am
> happy to take these into clk-next with your review.

Good, thanks.

As a side note, I'm currently working on redesigning Exynos cpufreq 
drivers, but this probably won't make it for 3.11, so these two patches 
are a good workaround for now to have the cpufreq working.

Best regards,
Tomasz

> Regards,
> Mike
> 
> > Tushar Behera (2):
> >   clk: samsung: Add MUX_FA macro to pass flag and alias
> >   clk: exynos4: Fix clock aliases for cpufreq related clocks
> >  
> >  drivers/clk/samsung/clk-exynos4.c |   21 +++++++++++----------
> >  drivers/clk/samsung/clk.h         |    3 +++
> >  2 files changed, 14 insertions(+), 10 deletions(-)
