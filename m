Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab3E3FZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:25:08 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55791 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3E3FZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
Date: Thu, 30 May 2013 10:55:04 +0530
Message-ID: <CAKrE-KcRNRJ-U_qR8UnVa1TJ6dJAF9ZDmuUX5dBOM3XxvOPZZg@mail.gmail.com>
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

Can you please check the performance with this patch set

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
