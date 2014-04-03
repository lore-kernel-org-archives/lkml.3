Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaDCDBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 23:01:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:60511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbaDCDBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 23:01:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,783,1389772800"; 
   d="scan'208";a="513803237"
Message-ID: <1396494088.2357.32.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/1] MAINTAINER: Update email address on thermal
 subsystem
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eduardo Valentin <eduardo.valentin@ti.com>
Date: Thu, 03 Apr 2014 11:01:28 +0800
In-Reply-To: <1396389834-52268-1-git-send-email-edubezval@gmail.com>
References: <1396389834-52268-1-git-send-email-edubezval@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 18:03 -0400, Eduardo Valentin wrote:
> I am updating my contact email address. For now on, patches
> on non ACPI / SoC thermal must be sent to edubezval@gmail.com.
> 
> Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

applied.

thanks,
rui
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 79031a5..79d7981 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8741,7 +8741,7 @@ F:	drivers/media/radio/radio-raremono.c
>  
>  THERMAL
>  M:	Zhang Rui <rui.zhang@intel.com>
> -M:	Eduardo Valentin <eduardo.valentin@ti.com>
> +M:	Eduardo Valentin <edubezval@gmail.com>
>  L:	linux-pm@vger.kernel.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
> @@ -8768,7 +8768,7 @@ S:	Maintained
>  F:	drivers/platform/x86/thinkpad_acpi.c
>  
>  TI BANDGAP AND THERMAL DRIVER
> -M:	Eduardo Valentin <eduardo.valentin@ti.com>
> +M:	Eduardo Valentin <edubezval@gmail.com>
>  L:	linux-pm@vger.kernel.org
>  S:	Supported
>  F:	drivers/thermal/ti-soc-thermal/


