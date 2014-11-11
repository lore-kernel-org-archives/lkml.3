Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaKKFQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:16:10 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48074 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaKKFQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:16:08 -0500
Date: Mon, 10 Nov 2014 21:16:04 -0800
From: Darren Hart <dvhart@infradead.org>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        jim.epost@gmail.com
Subject: Re: [PATCH] platform: hp_accel: Add SERIO_I8042 as a dependency
 since it now includes i8042.h/serio.h
Message-ID: <20141111051603.GA56947@vmdeb7>
References: <1415645982-9472-1-git-send-email-giedriuswork@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415645982-9472-1-git-send-email-giedriuswork@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:59:42PM +0200, Giedrius Statkevicius wrote:
> Make hp_accel dependent on SERIO_I8042 in the Kconfig because since commit
> a4c724d0723b078e4ab4670e557cda1795036a7a ('platform: hp_accel: add a i8042
> filter to remove HPQ6000 data from kb bus stream') hp_accel includes i8042.h
> and serio.h.
> 
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Giedrius Statkevičius <giedriuswork@gmail.com>
> ---
>  drivers/platform/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 4dcfb71..7d146e68 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -202,6 +202,7 @@ config TC1100_WMI
>  config HP_ACCEL
>  	tristate "HP laptop accelerometer"
>  	depends on INPUT && ACPI
> +        depends on SERIO_I8042

Whitespace error, this should be a tab. I suggest making whitespace visible in
your editor to avoid this kind of thing.

I've corrected it and queued it.

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
