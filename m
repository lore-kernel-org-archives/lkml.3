Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaAFLWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:22:20 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:61309 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaAFLWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:22:18 -0500
Date: Mon, 6 Jan 2014 11:22:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, mturquette@linaro.org,
        kgene.kim@samsung.com, patches@linaro.org
Subject: Re: [PATCH RESEND 3/4] mfd: sec-core: Add cells for S5M8767-clocks
Message-ID: <20140106112212.GP23772@lee--X1>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-4-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388053141-30085-4-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Dec 2013, Tushar Behera wrote:

> S5M8767 chip has 3 crystal oscillators running at 32KHz. These are
> supported by s2mps11-clk driver.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> CC: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/sec-core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
