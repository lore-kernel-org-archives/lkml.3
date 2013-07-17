Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3GQL6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:58:53 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53016 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3GQL6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:58:52 -0400
Date: Wed, 17 Jul 2013 12:58:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 2/2] mfd: wm8994: Remove check for active audio in
 runtime suspend
Message-ID: <20130717115846.GF3336@laptop>
References: <1374060037-18527-1-git-send-email-broonie@kernel.org>
 <1374060037-18527-2-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374060037-18527-2-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Since enabling VMID takes a runtime PM reference there is no need to
> suppress suspend when doing a runtime suspend. Similarly the digital
> inputs and outputs are DAPM widgets and therefore the ASoC core will
> be holding a reference for them.
> 
> This used to be required when integration with system suspend was being
> bodged.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/wm8994-core.c | 30 +-----------------------------
>  1 file changed, 1 insertion(+), 29 deletions(-)
> 
> diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c

Happy with this. Will apply when I fully understand 1/2.

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
