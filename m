Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaDXIeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:34:13 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:57790 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbaDXIeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:34:10 -0400
MIME-Version: 1.0
In-Reply-To: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
References: <1397782021-31396-1-git-send-email-tim.kryger@linaro.org>
Date: Thu, 24 Apr 2014 10:34:09 +0200
Message-ID: <CAPDyKFpZ_0U+y=ho8c4nmaoT3cB-v6+cwsWm0O8TrTrL-yHzCg@mail.gmail.com>
Subject: Re: [PATCH 0/2] SDHCI should use more common MMC structs and functions
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Chris Ball <chris@printf.net>, Mike Looijmans <mike.looijmans@topic.nl>,
        Andrew Bresticker <abrestic@chromium.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 02:46, Tim Kryger <tim.kryger@linaro.org> wrote:
> This series updates SDHCI to use the common regulator infrastructure that mmc
> core provides.
>
> Tim Kryger (2):
>   mmc: sdhci: Use supplies in common mmc_host struct
>   mmc: sdhci: Use common mmc_regulator_get_supply

Both patches looks good, but I would prefer if you could squash them
into one patch.

Kind regards
Ulf Hansson

>
>  drivers/mmc/host/sdhci.c  |   96 +++++++++++++++++----------------------------
>  include/linux/mmc/sdhci.h |    3 --
>  2 files changed, 35 insertions(+), 64 deletions(-)
>
> --
> 1.7.9.5
>
