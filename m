Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbbATNSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:18:36 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:44692 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753553AbbATNSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:18:34 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH 2/8] soc: Add MediaTek pericfg controller support
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
	 <1421747231-554-3-git-send-email-s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jan 2015 21:18:30 +0800
Message-ID: <1421759910.11671.69.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 10:47 +0100, Sascha Hauer wrote:
<...>
> diff --git a/drivers/soc/mediatek/mtk-pericfg.c b/drivers/soc/mediatek/mtk-pericfg.c
> index b7ee902..aa9a7eb 100644
> --- a/drivers/soc/mediatek/mtk-pericfg.c
> +++ b/drivers/soc/mediatek/mtk-pericfg.c
> @@ -1,6 +1,5 @@
>  /*
>   * Copyright (c) 2014 MediaTek Inc.
> - * Author: Flora Fu <flora.fu@mediatek.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as

Hi Sascha,

I believe you want to add mtk-pericfg.c here instead of adding it in
first patch and only change author here.

Joe.C



