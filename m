Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbaDPHoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:44:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51407 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaDPHof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:44:35 -0400
Date: Wed, 16 Apr 2014 10:44:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Tanaka <thomas.tanaka@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        bernat.ada@gmail.com, jg1.han@samsung.com, keescook@chromium.org,
        peter.p.waskiewicz.jr@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] staging: dgrp: Fixed coding style
Message-ID: <20140416074410.GO26890@mwanda>
References: <1397609680-10321-1-git-send-email-thomas.tanaka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397609680-10321-1-git-send-email-thomas.tanaka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, Apr 15, 2014 at 05:54:39PM -0700, Thomas Tanaka wrote:
> Fixed line width > 80
> 
> Signed-off-by: Thomas Tanaka <thomas.tanaka@gmail.com>
> ---
>  drivers/staging/dgrp/dgrp_sysfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/dgrp/dgrp_sysfs.c b/drivers/staging/dgrp/dgrp_sysfs.c
> index 2f9345f..93803e0c 100644
> --- a/drivers/staging/dgrp/dgrp_sysfs.c
> +++ b/drivers/staging/dgrp/dgrp_sysfs.c
> @@ -108,8 +108,8 @@ int dgrp_create_class_sysfs_files(void)
>  	ret = sysfs_create_group(&dgrp_class_global_settings_dev->kobj,
>  		&dgrp_global_settings_attribute_group);
>  	if (ret) {
> -		pr_alert("%s: failed to create sysfs global settings device attributes.\n",
> -			__func__);
> +		pr_alert("%s: failed to create sysfs global settings device
> +			 attributes.\n", __func__);

The original was fine.  It doesn't cause a checkpatch.pl warning.  The
new one is buggy and won't print the correct text.

regards,
dan carpenter


