Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaEGMql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 08:46:41 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:57940 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085AbaEGMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 08:46:40 -0400
Date: Wed, 7 May 2014 13:46:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Mike Rapoport'" <mike.rapoport@ravellosystems.com>
Subject: Re: [PATCH 3/4] mfd: tps6586x: Make of_device_id array const
Message-ID: <20140507124632.GH5206@lee--X1>
References: <01f001cf69cc$8dd3b320$a97b1960$%han@samsung.com>
 <01f601cf69cd$981f3d30$c85db790$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01f601cf69cd$981f3d30$c85db790$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014, Jingoo Han wrote:

> Make of_device_id array const, because all OF functions
> handle it as const.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/tps6586x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
