Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbaGXPCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:02:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46787 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759184AbaGXPCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:02:49 -0400
Date: Thu, 24 Jul 2014 16:02:43 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] mfd: core: Use devm_kzalloc
Message-ID: <20140724150243.GE7063@lee--X1>
References: <20140719083010.GA2882@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140719083010.GA2882@himangi-Dell>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2014, Himangi Saraogi wrote:

> This patch introduces the use of devm_kzalloc instead of the
> corresponding unmanaged version and does away with the kfrees in the
> probe and remove functions. Also, a label is done away with.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/mfd/tps6105x.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
