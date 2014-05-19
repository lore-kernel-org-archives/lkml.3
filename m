Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaESI0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:26:13 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54288 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbaESI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:26:10 -0400
Date: Mon, 19 May 2014 09:26:00 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Milo Kim <milo.kim@ti.com>
Subject: Re: [PATCH 06/16] mfd: lp3943: Make mfd_cell array const
Message-ID: <20140519082600.GM2339@lee--X1>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
 <1399978733-13662-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399978733-13662-6-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Krzysztof Kozlowski wrote:

> mfd_add_devices() expects array of struct mfd_cell to be const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/mfd/lp3943.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
