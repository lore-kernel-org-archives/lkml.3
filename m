Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaEHTb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:31:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41036 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbaEHTbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:31:55 -0400
Message-ID: <536BDB88.8090106@ti.com>
Date: Thu, 8 May 2014 15:31:20 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Olof Johansson <olof@lixom.net>, Tony Prisk <linux@prisktech.co.nz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: configs: drop CONFIG_COMMON_CLK_DEBUG
References: <1398755224-7530-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1398755224-7530-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 April 2014 03:07 AM, Lad Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> this patch removes COMMON_CLK_DEBUG config option
> from defconfig file as this config option is obsolete.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  Changes for v2:
>  a> Dropped imx defconfig files as suggested by Shawn.
>  

>  arch/arm/configs/keystone_defconfig     |    1 -
Am picking the keystone part from this patch. Thanks.
You might want split this patch so that others can pick it
up


