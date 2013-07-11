Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab3GKLT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:19:28 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59150 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab3GKLT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:19:27 -0400
Date: Thu, 11 Jul 2013 12:19:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] mfd: sec: Add register cache for interrupt mask registers
Message-ID: <20130711111920.GI25601@gmail.com>
References: <1372787476-10145-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372787476-10145-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Jul 2013, Mark Brown wrote:

> From: Mark Brown <broonie@linaro.org>
> 
> The performance of regmap-irq is improved if the interrupt mask registers
> can be cached since it does read/modify/update cycles so start using the
> register cache infrastructure for those registers. We should use this more
> widely but I don't have a datasheet and this is a nice, conservative
> starting point.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/mfd/sec-core.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
