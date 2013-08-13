Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab3HMRTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:19:08 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:36519 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3HMRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:19:06 -0400
Date: Tue, 13 Aug 2013 18:18:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] mfd: ti_am335x_tscadc: Update reg_cache variable in clr
 function
Message-ID: <20130813171859.GL15278@lee--X1>
References: <1376412056-20736-1-git-send-email-zubair.lutfullah@gmail.com>
 <1376412056-20736-2-git-send-email-zubair.lutfullah@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1376412056-20736-2-git-send-email-zubair.lutfullah@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Zubair Lutfullah wrote:

> The reg_cache variable should be updated with current
> steps in the reg_se register. Then the mask should
> apply and clear the register. Previously, the reg_cache
> can be an old redundant value that isn't updated.
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
> ---
>  drivers/mfd/ti_am335x_tscadc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
