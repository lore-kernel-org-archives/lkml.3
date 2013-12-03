Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3LCOW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:22:58 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33097 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3LCOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:22:57 -0500
Date: Tue, 3 Dec 2013 14:22:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MFD: ab8500: use irqdomain to map interrupts
Message-ID: <20131203142251.GC28159@lee--X1>
References: <1386079914-23807-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386079914-23807-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All subdrivers use the irqdomain to demux AB8500 IRQs but here
> in the hierarchical path we find a leftover instance using the
> hard-coded IRQ base. Convert it to use irqdomain with a
> oneliner.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
