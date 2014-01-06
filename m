Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaAFKnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:43:35 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61855 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaAFKnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:43:33 -0500
Date: Mon, 6 Jan 2014 10:43:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        linaro-networking@linaro.org, linaro-kernel@lists.linaro.org,
        Danke Xie <d.xie@sta.samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v2] mfd: twl6030: Fix endianness problem in IRQ
 handler
Message-ID: <20140106104328.GJ23772@lee--X1>
References: <1387818706-6129-1-git-send-email-taras.kondratiuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387818706-6129-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013, Taras Kondratiuk wrote:

> From: Danke Xie <d.xie@sta.samsung.com>
> 
> The current TWL 6030 IRQ handler assumes little endianness.
> This change makes it endian-neutral.
> 
> Signed-off-by: Danke Xie <d.xie@sta.samsung.com>
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
> v2: fixed sparse warning
> v1: https://patchwork.kernel.org/patch/2974331/
> 
> drivers/mfd/twl6030-irq.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
