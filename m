Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653Ab3GQL7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:59:31 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47490 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3GQL7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:59:30 -0400
Date: Wed, 17 Jul 2013 12:59:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: wm8997: Make Kconfig prompt for WM8997 more
 consistent
Message-ID: <20130717115924.GG3336@laptop>
References: <1374060069-18589-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374060069-18589-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> The Kconfig prompt for WM8997 says "Support for..." while the other MFD
> Kconfigs (including the adjacent ones for other Arizona devices) just
> list the device name which sticks out like a sore thumb when doing
> configuration.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
