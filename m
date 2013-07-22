Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab3GVIZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:25:31 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46812 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3GVIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:25:29 -0400
Date: Mon, 22 Jul 2013 09:25:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        koen@dominion.thruhere.net
Subject: Re: [PATCH 4/4] mfd: input: arm: dts: doc: ti_am335x: typo fixes
 (coordiante -> coordinate)
Message-ID: <20130722082516.GE4681@laptop>
References: <1374337656-6393-1-git-send-email-zubair.lutfullah@gmail.com>
 <1374337656-6393-5-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374337656-6393-5-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Jul 2013, Zubair Lutfullah wrote:

> Did a grep for 'coordiante' and replaced them all with 'coordinate'
> ---
>  .../bindings/input/touchscreen/ti-tsc-adc.txt      |    4 ++--
>  arch/arm/boot/dts/am335x-evm.dts                   |    2 +-
>  drivers/input/touchscreen/ti_am335x_tsc.c          |    2 +-
>  drivers/mfd/ti_am335x_tscadc.c                     |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)

Once these DT bindings move from a development state to something more
concrete, I guess misspellings such as these will just have to remain
incorrect. However, as we are still in a state of development you can
have my:

Acked-by: Lee Jones <lee.jones@linaro.org>

... for the MFD part. 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
