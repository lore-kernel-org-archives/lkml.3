Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaBYIyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:54:13 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33139 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBYIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:54:11 -0500
Date: Tue, 25 Feb 2014 08:54:03 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, David Jander <david@protonic.nl>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH V1 1/3] include/linux/mfd/da9052/da9052: Add new BC chip
Message-ID: <20140225085403.GC19099@lee--X1>
References: <201402191636.s1JGarhP017640@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201402191636.s1JGarhP017640@swsrvapps-02.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add the hash define for the new variant of the DA9053 PMIC called BC.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> ---
> 
> This patch is relative to linux-next repository tag next-20140219
> 
> This patch must be applied before the others in this patch series
> or the drivers that the other patches modify will not compile.
> 
>  include/linux/mfd/da9052/da9052.h |    1 +
>  1 file changed, 1 insertion(+)

Applied with an amended/corrected subject line.

> diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
> index 21e21b8..bba65f5 100644
> --- a/include/linux/mfd/da9052/da9052.h
> +++ b/include/linux/mfd/da9052/da9052.h
> @@ -83,6 +83,7 @@ enum da9052_chip_id {
>  	DA9053_AA,
>  	DA9053_BA,
>  	DA9053_BB,
> +	DA9053_BC,
>  };
>  
>  struct da9052_pdata;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
