Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab3CYD17 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:27:59 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:54664 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3CYD16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:27:58 -0400
MIME-Version: 1.0
In-Reply-To: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
Date: Mon, 25 Mar 2013 08:57:56 +0530
Message-ID: <CAKrE-Kfgw+ofmkN+aMVNeeLm=+4owJ0U=qAmj2o0oARm6BSCQQ@mail.gmail.com>
Subject: Re: [PATCH V3 0/5] Add polling support for 64xx spi controller
From: Girish KS <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello grant,

any comments on this patch series?


On Wed, Mar 13, 2013 at 12:13 PM, Girish K S <girishks2000@gmail.com> wrote:
> [PATCH 1/5]: fixes the error handling in the interrupt handler
> [PATCH 2/5]: The existing driver support partial polling mode.
>              This patch modifies the current driver to support
>              only polling mode.
> [PATCH 3/5]: provision to support SoC's with dedicated i/o pins
> [PATCH 4/5]: provision to support dedicated cs pin
> [PATCH 5/5]: support exynos5440 SoC in polling mode
>
> Tested this patch on exynos5250 in dma mode, and exynos5440 in
> polling mode.
>
> changes in v3:
>             Rebase it to the linus's master branch. After rebase
> there was a logical code change due to the merge of generic dma
> patch. resolved the merge conflicts and tested for the functionality
>
> Girish K S (5):
>   spi: s3c64xx: modified error interrupt handling and init
>   spi: s3c64xx: added support for polling mode
>   spi: s3c64xx: Added provision for non-gpio i/o's
>   spi: s3c64xx: Added provision for dedicated cs pin
>   spi: s3c64xx: Added support for exynos5440 spi
>
>  drivers/spi/spi-s3c64xx.c                 | 204 +++++++++++++++++++++---------
>  include/linux/platform_data/spi-s3c64xx.h |   3 +
>  2 files changed, 148 insertions(+), 59 deletions(-)
>
> --
> 1.8.0
>
