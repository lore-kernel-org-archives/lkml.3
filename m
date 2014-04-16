Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbaDPKBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:01:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39332 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaDPKBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:01:11 -0400
Date: Wed, 16 Apr 2014 11:01:05 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        AnilKumar Ch <anilkumar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65217: Remove *rdev[] from struct tps65217
Message-ID: <20140416100105.GH4754@lee--X1>
References: <1397562458.24265.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397562458.24265.3.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Now this driver uses devm_regulator_register() so we don't need to save rdev
> pointer to tps->rdev[i] for cleanup.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/regulator/tps65217-regulator.c | 3 ---
>  include/linux/mfd/tps65217.h           | 1 -
>  2 files changed, 4 deletions(-)

For the MFD part:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
