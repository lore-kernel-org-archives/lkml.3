Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaGZJSN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 05:18:13 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:64953 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaGZJSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 05:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
References: <1405100893-32107-1-git-send-email-gdjakov@mm-sol.com>
Date: Sat, 26 Jul 2014 11:18:10 +0200
Message-ID: <CAPDyKFqZ88W3zuaTDzahF=eJwqHZcRzUDOMR_O53W8WftxPL3g@mail.gmail.com>
Subject: Re: [PATCH 0/3] mmc: sdhci-msm: Minor fixes and cleanups
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 19:48, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> This patchset contains fixes in the documentation, cleanups
> and enables COMPILE_TEST for better testing coverage.
>
> Georgi Djakov (3):
>   mmc: sdhci-msm: Fix the binding example
>   mmc: sdhci-msm: Remove unnecessary header file inclusion
>   mmc: sdhci-msm: Get COMPILE_TEST support
>
>  .../devicetree/bindings/mmc/sdhci-msm.txt          |    8 ++++----
>  drivers/mmc/host/Kconfig                           |    2 +-
>  drivers/mmc/host/sdhci-msm.c                       |    1 -
>  3 files changed, 5 insertions(+), 6 deletions(-)
>

Thanks! Applied for next!

Kind regards
Uffe

> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
