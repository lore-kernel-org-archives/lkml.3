Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3FJD2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 23:28:36 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60274 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3FJD2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 23:28:35 -0400
MIME-Version: 1.0
In-Reply-To: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
Date: Mon, 10 Jun 2013 08:58:33 +0530
Message-ID: <CAKrE-Kd22BM=zS=KZN_a69yAN8zSSdq-Rh-x_dsNRZD4JffPwg@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Polling support for s3c64xx spi controller
From: Girish KS <girishks2000@gmail.com>
To: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

pls let me know if there is any issue with this series



On Mon, May 20, 2013 at 12:21 PM, Girish K S <girishks2000@gmail.com> wrote:
> This patch series adds support for the polling mode only. Also 2nd patch
> in the series adds support for dedicated cs pin. After Thomas's patch for
> using default gpio is merged(commit id: 00ab539), one of the patch in this
> series is dropped and new series is generated.
>
> Girish K S (3):
>   spi: s3c64xx: added support for polling mode
>   spi: s3c64xx: Added provision for dedicated cs pin
>   spi: s3c64xx: Added support for exynos5440 spi
>
>  drivers/spi/spi-s3c64xx.c |  197 ++++++++++++++++++++++++++++++++-------------
>  1 files changed, 140 insertions(+), 57 deletions(-)
>
> --
> 1.7.5.4
>
