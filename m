Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3EKM1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 08:27:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48407 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3EKM1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 08:27:42 -0400
Date: Sat, 11 May 2013 13:27:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Russ Anderson <rja@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v10 10/11] arm, change reboot_mode to use enum
	reboot_mode
Message-ID: <20130511122705.GZ18614@n2100.arm.linux.org.uk>
References: <1368273447-11958-1-git-send-email-holt@sgi.com> <1368273447-11958-11-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368273447-11958-11-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 06:57:26AM -0500, Robin Holt wrote:
> diff --git a/arch/arm/mach-ixp4xx/include/mach/timex.h b/arch/arm/mach-ixp4xx/include/mach/timex.h
> index c9e930f..729b2db 100644
> --- a/arch/arm/mach-ixp4xx/include/mach/timex.h
> +++ b/arch/arm/mach-ixp4xx/include/mach/timex.h
> @@ -3,7 +3,7 @@
>   * 
>   */
>  
> -#include <mach/hardware.h>
> +// #include <mach/hardware.h>
>  
>  /*
>   * We use IXP425 General purpose timer for our timer needs, it runs at 

Apart from this, everything else here looks fine from a quick scan.
If the above is needed to fix some build error, it should be a separate
patch sent to the arm-soc people.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Thanks.
