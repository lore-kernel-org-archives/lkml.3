Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3GQMYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:24:44 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36988 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3GQMYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:24:43 -0400
Date: Wed, 17 Jul 2013 13:24:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/2] mfd: wm8994: Remove unneeded check for JACKDET
Message-ID: <20130717122437.GH3336@laptop>
References: <1374063369-20444-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374063369-20444-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> The jack detection code holds runtime PM references when required so
> there is no need for suspend to do any checks.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm8994-core.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c

Thanks for the clarification.

Both patches applied.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
