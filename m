Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966010AbaGRRTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:19:23 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58930 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965749AbaGRRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:19:20 -0400
Date: Fri, 18 Jul 2014 10:17:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Barry Song <baohua@kernel.org>, Binghua Duan <Binghua.Duan@csr.com>,
        Xianglong Du <Xianglong.Du@csr.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: sirfsoc-onkey - fix GPL v2 license string typo
Message-ID: <20140718171754.GA22605@core.coreip.homeip.net>
References: <20140715232445.24052.13767.stgit@bhelgaas-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715232445.24052.13767.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:24:45PM -0600, Bjorn Helgaas wrote:
> Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
> "GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
> kernel.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Applied, thank you.

> ---
>  drivers/input/misc/sirfsoc-onkey.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/input/misc/sirfsoc-onkey.c b/drivers/input/misc/sirfsoc-onkey.c
> index e4104f9b2e6d..fed5102e1802 100644
> --- a/drivers/input/misc/sirfsoc-onkey.c
> +++ b/drivers/input/misc/sirfsoc-onkey.c
> @@ -213,7 +213,7 @@ static struct platform_driver sirfsoc_pwrc_driver = {
>  
>  module_platform_driver(sirfsoc_pwrc_driver);
>  
> -MODULE_LICENSE("GPLv2");
> +MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Binghua Duan <Binghua.Duan@csr.com>, Xianglong Du <Xianglong.Du@csr.com>");
>  MODULE_DESCRIPTION("CSR Prima2 PWRC Driver");
>  MODULE_ALIAS("platform:sirfsoc-pwrc");
> 

-- 
Dmitry
