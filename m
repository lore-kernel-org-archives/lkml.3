Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3LWS7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 13:59:32 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:58016 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3LWS7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 13:59:30 -0500
X-Auth-Info: Do3OuLhFj9fuEikDsdGpUoAMECJFLoR+Rh7Hlg9koJM=
From: Marek Vasut <marex@denx.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCHv5 RESEND 0/4] iio: mxs-lradc: add support to optional divider_by_two
Date: Mon, 23 Dec 2013 19:54:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>, lars@metafoo.de, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1387820884-28140-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312231954.36124.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 23, 2013 at 06:48:00 PM, Alexandre Belloni wrote:
> Hello,
> 
> This is v5 of the patchset that adds support to the optional divider_by_two
> of LRADC channels.
> 
> Changes since v4:
>  - moved enum mxs_lradc_divbytwo to the third patch
>  - added a fourth patch to convert is_divided to a bitmap. I did that in a
>    separated patch for review and copyright attribution purposes.
> 
> This was tested on a custom i.MX28 platform.
> 
> Alexandre Belloni (1):
>   iio: mxs-lradc: convert is_divided to a bitmap
> 
> Hector Palacios (3):
>   iio: mxs-lradc: add scale attribute to channels
>   iio: mxs-lradc: add scale_available file to channels
>   iio: mxs-lradc: add write_raw function to modify scale
> 
>  drivers/staging/iio/adc/mxs-lradc.c | 222
> +++++++++++++++++++++++++++++++++++- 1 file changed, 219 insertions(+), 3
> deletions(-)

Why is there a resend please ?

Best regards,
Marek Vasut
