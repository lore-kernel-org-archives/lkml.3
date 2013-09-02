Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3IBISH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:18:07 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:42108 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3IBISF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:18:05 -0400
Date: Mon, 2 Sep 2013 09:17:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: twl6040: Use regmap for register cache
Message-ID: <20130902081759.GC12341@lee--X1>
References: <1377967699-10277-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377967699-10277-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Aug 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> Rather then open coding a cache of the vibra control registers use the
> regmap cache code.  Also cache the interrupt mask register, providing
> a small performance improvement for the interrupt code.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
> 
> I'm hoping to have some ASoC improvements to build on top of this (there
> is ASoC level register caching for the device) so it might make sense to
> apply this via ASoC.
> 
>  drivers/mfd/twl6040.c       | 43 ++++++++++++++++++++++++++++++-------------
>  include/linux/mfd/twl6040.h |  1 -
>  2 files changed, 30 insertions(+), 14 deletions(-)

Applied with Peter's Ack, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
