Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab3BEJ4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:56:37 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:43076 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3BEJ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:56:33 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <1359980088-20799-1-git-send-email-a.kesavan@samsung.com>
References: <1358515490-7565-1-git-send-email-a.kesavan@samsung.com>
	<1359980088-20799-1-git-send-email-a.kesavan@samsung.com>
Date: Tue, 5 Feb 2013 18:56:31 +0900
X-Google-Sender-Auth: a4p5wSm_aF_wN73OjJZauTjR1Bw
Message-ID: <CAJ0PZbT5csFuLpxTTTXqCOApYsOKM4z8r-cTAL3w3vLmA8mKvw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] PM: Devfreq: Add Exynos5-bus devfreq driver for Exynos5250
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 9:14 PM, Abhilash Kesavan <a.kesavan@samsung.com> wrote:
> Exynos5-bus device devfreq driver monitors PPMU counters and
> adjusts operating frequencies and voltages with OPP. ASV should
> be used to provide appropriate voltages as per the speed group
> of the SoC rather than using a constant 1.025V.

applied. thanks.



ps. Devfreq patches are stacking up at devfreq's for-rafael branch and
will be pull-requested for 3.9 soon.



>
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Cc: Jonghwan Choi <jhbird.choi@samsung.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> ---
> Changes since RFC v1:
> * Moved the Exynos5 PPMU driver to machine specific directory
> * Migrated to the PM QOS framework
> Changes since v2:
> * Moved the PPMU driver to drivers/devfreq/exynos
> * Fixed whitespace, commenting, empty lines in PPMU driver
> Changes since v3:
> * Removed the custom devfreq monitor and PPMU polling function
> * Moved exynos5 PPMU access functions to the devfreq driver
> Changes since v4:
> * Fixed compilation errors due to presence of devinit/devexit
> * Moved exynos ppmu header to the drivers/devfreq/exynos directory
>

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
