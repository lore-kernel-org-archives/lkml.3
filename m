Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbaCSJOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:14:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46328 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbaCSJOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:14:10 -0400
Date: Wed, 19 Mar 2014 09:14:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-core: Fix uninitialized 'regmap_rtc' on S2MPA01
Message-ID: <20140319091404.GF31687@lee--X1>
References: <20140318110947.GR25478@lee--X1>
 <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395148286-32002-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Initialize the 'regmap_rtc' on S2MPA01 to some sane value. Sane at least
> for S5M87X chipsets, not S2MPS/S2MPA but it won't be used because
> rtc-s5m driver does not support S2MPA01.
> 
> This fixes following error:
> drivers/mfd/sec-core.c:342:45: warning: ‘regmap_rtc’ may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/sec-core.c |    7 +++++++
>  1 file changed, 7 insertions(+)

Please don't send patches in the middle of threads like this (v2's are
a different story as it saves on re-sending entire patch-sets), as I
very nearly missed it.

We already have drivers doing similar things so I'll apply this as a
temporary fix, but please find something a little less 'hacky' to
supersede it _soon_.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
