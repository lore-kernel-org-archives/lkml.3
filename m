Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaCJSNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:13:14 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54139 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaCJSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:13:13 -0400
Date: Mon, 10 Mar 2014 18:13:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm5102: Mark register write sequencer control 3
 readable
Message-ID: <20140310181307.GC16697@lee--X1>
References: <1394473334-22049-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394473334-22049-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Mark Brown <broonie@linaro.org>
> 
> During init the core checks if the wm5102 has finished starting by reading
> register 0x19 and looking at the value. This read always fails since this
> is not a readable register, mark it as being one. While we're at it provide
> a constant for the register name (as supplied by Charles Keepax).
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/arizona-core.c            | 3 ++-
>  drivers/mfd/wm5102-tables.c           | 1 +
>  include/linux/mfd/arizona/registers.h | 1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
