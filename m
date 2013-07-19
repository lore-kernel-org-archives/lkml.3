Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576Ab3GSN4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 09:56:50 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53859 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760539Ab3GSN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 09:56:47 -0400
X-Auth-Info: vurXLP0s7OSatQz0qPhvESsMUVrUD3pXxFY9y3IIfD0=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v2 1/5] iio: mxs-lradc: change the realbits to 12
Date: Fri, 19 Jul 2013 15:56:46 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        alexandre.belloni@free-electrons.com, jic23@kernel.org,
        lars@metafoo.de, fabio.estevam@freescale.com
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-2-git-send-email-hector.palacios@digi.com>
In-Reply-To: <1374225208-28940-2-git-send-email-hector.palacios@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307191556.46857.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> The LRADC virtual channels have an 18 bit field to store the sum of up
> to 2^5 accumulated samples. The read_raw function however only operates
> over a single sample (12 bit resolution).
> In order to use this field for scaling operations, we need it to be the
> exact resolution value of the LRADC.
> Besides, the driver was using an 18 bit mask (LRADC_CH_VALUE_MASK) to
> report touch coordinates to userland. A 12 bit mask should be used instead
> or else the touch libraries will expect a coordinates range between 0
> and 0x3ffff (18 bits), instead of between 0 and 0xfff (12 bits).
> 
> Signed-off-by: Hector Palacios <hector.palacios@digi.com>

Acked-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
