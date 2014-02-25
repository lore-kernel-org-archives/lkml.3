Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaBYI5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:57:13 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47094 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbaBYI5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:57:09 -0500
Date: Tue, 25 Feb 2014 08:57:01 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Message-ID: <20140225085701.GD19099@lee--X1>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add support for a new BC variant of the DA9053 PMIC.
> 
> There is one difference between it and the AA, BA and BB.
> 
> This patch also corrects a typing mistake in one of the BA
> name strings that was incorrectly typed as "ab".
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> ---
> 
> This patch is relative to linux-next repository tag next-20140219

That's not generally a good idea.

Please use a Mainline version (inc. -rcs).

> This patch depends on patch number 1 of this patch
> series being applied first or it will not compile.
> 
>  drivers/mfd/da9052-i2c.c |    5 ++++-
>  drivers/mfd/da9052-spi.c |    1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
