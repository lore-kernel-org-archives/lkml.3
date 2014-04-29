Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaD2GUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:20:08 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:62795 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaD2GUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140429061417.GJ16451@dragon>
References: <1398504922-9223-1-git-send-email-prabhakar.csengg@gmail.com> <20140429061417.GJ16451@dragon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 29 Apr 2014 11:49:35 +0530
Message-ID: <CA+V-a8vnha1Pk7pJ0nRizk=A+b-w_bAyS6E+32dPimSBCMg-Dg@mail.gmail.com>
Subject: Re: [PATCH] ARM: configs: drop CONFIG_COMMON_CLK_DEBUG
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 11:44 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Sat, Apr 26, 2014 at 03:05:22PM +0530, Lad Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> this patch removes COMMON_CLK_DEBUG config option
>> from defconfig file as this config option is obsolete.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  arch/arm/configs/imx_v4_v5_defconfig    |    1 -
>>  arch/arm/configs/imx_v6_v7_defconfig    |    1 -
> ...
>>  arch/arm/configs/mxs_defconfig          |    1 -
>
> Please drop these 3 files from your patch.  The obsolete
> COMMON_CLK_DEBUG option has been removed from two of them on my branch
> by savedefconfig, and we will address the remaining one in another
> patch.
>
OK will post the updated patch dropping these 3 files.

Regards,
--Prabhakar Lad
