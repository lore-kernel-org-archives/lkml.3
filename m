Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaESIL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:11:28 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44321 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaESILY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:11:24 -0400
Date: Mon, 19 May 2014 09:11:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: ipaq-micro: Use devm_ioremap_resource()
Message-ID: <20140519081119.GG2339@lee--X1>
References: <001d01cf6f23$00900250$01b006f0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <001d01cf6f23$00900250$01b006f0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use devm_ioremap_resource() because devm_request_and_ioremap() is
> obsoleted by devm_ioremap_resource().
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/ipaq-micro.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Applied with Linus' Ack, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
