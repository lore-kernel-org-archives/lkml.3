Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114Ab3LIAUP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 19:20:15 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:45450 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab3LIAUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 19:20:12 -0500
X-Auth-Info: 1HS7TGwp6H9JTabMGzk0BANIaiqcpewuZoDSrfBaWJ8=
From: Marek Vasut <marex@denx.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCHv4 0/3] iio: mxs-lradc: add support to optional divider_by_two
Date: Mon, 9 Dec 2013 01:18:45 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Jonathan Cameron <jic23@kernel.org>, lars@metafoo.de, harald@ccbib.org,
        hector.palacios@digi.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1386375840-24984-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312090118.45749.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 07, 2013 at 01:23:57 AM, Alexandre Belloni wrote:
> Hello,
> 
> This is v4 of the patchset that adds support to the optional divider_by_two
> of LRADC channels.
> 
> Changes since v3:
>  - removed DT bindings for vref_mv (was the second patch of the series)
>  - rebased on v3.13.0-rc3
>  - the first patch of the previous series had been applied previously
>  - this will apply after https://lkml.org/lkml/2013/12/6/676
> 
> This was tested on a custom i.MX28 platform.
> Could someone please test on an i.MX23?
> 
> Hector Palacios (3):
>   iio: mxs-lradc: add scale attribute to channels
>   iio: mxs-lradc: add scale_available file to channels
>   iio: mxs-lradc: add write_raw function to modify scale
> 
>  drivers/staging/iio/adc/mxs-lradc.c | 222
> +++++++++++++++++++++++++++++++++++- 1 file changed, 219 insertions(+), 3
> deletions(-)

Looks OK to me for all but the tweaks Jonathan requested, thanks!

Whole series otherwise:

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
