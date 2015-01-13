Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbbAMMab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:30:31 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:56380 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbAMMa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:30:28 -0500
MIME-Version: 1.0
In-Reply-To: <1420384548-7816-1-git-send-email-jszhang@marvell.com>
References: <1420384548-7816-1-git-send-email-jszhang@marvell.com>
Date: Tue, 13 Jan 2015 13:30:27 +0100
Message-ID: <CAPDyKFpE-rgBB66R3iS_rQssa8z8LsTz=e6asi+8_EdUMfTBfA@mail.gmail.com>
Subject: Re: [PATCH next 0/2] mmc: sdhci-pxav3: fix unbalanced pm and clock issues
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: Chris Ball <chris@printf.net>, Peter Griffin <peter.griffin@linaro.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 January 2015 at 16:15, Jisheng Zhang <jszhang@marvell.com> wrote:
> These two patches fix unbalanced pm and clock issues. The clock unbalance
> issue would cause power consumption regression because the clock will never
> be gated at runtime PM suspend.
>
> Jisheng Zhang (2):
>   mmc: sdhci-pxav3: fix unbalanced clock issues during probe
>   mmc: sdhci-pxav3: fix pm unbalanced issue in -> remove()
>
>  drivers/mmc/host/sdhci-pxav3.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> --
> 2.1.4
>

Thanks! Applied for next.

Kind regards
Uffe
