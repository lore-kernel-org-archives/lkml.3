Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3GEWsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:48:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35820 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3GEWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:48:29 -0400
Date: Fri, 5 Jul 2013 23:48:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, shuahkhan@gmail.com
Subject: Re: [PATCH] arm: Convert sa1111 platform and bus legacy pm_ops to
	dev_pm_ops
Message-ID: <20130705224814.GM24642@n2100.arm.linux.org.uk>
References: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373064297-13582-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 04:44:57PM -0600, Shuah Khan wrote:
> Convert arch/arm/common/sa1111 platform and bus legacy pm_ops to dev_pm_ops.
> This change also updates the use of COMFIG_PM to CONFIG_PM_SLEEP as this
> platform and bus code implements PM_SLEEP ops and not the PM_RUNTIME ops.
> Compile tested.

Err...

> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index 2a64c12..95594f0 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -1321,7 +1321,7 @@ static int sa1111_bus_resume(struct device *dev)
>  }
>  static SIMPLE_DEV_PM_OPS(sa1111_bus_dev_pm_ops, sa1111_bus_suspend,
>  			 sa1111_bus_resume);
> -#endif 
> +#endif

Patch doesn't match description.
