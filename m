Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaGPJ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:27:26 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:64799 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710AbaGPJ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:27:23 -0400
Message-ID: <1405502840.4408.2.camel@x220>
Subject: Re: [PATCH 04/19] serial: samsung: Remove support for legacy clock
 code
From: Paul Bolle <pebolle@tiscali.nl>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Date: Wed, 16 Jul 2014 11:27:20 +0200
In-Reply-To: <1404496099-26708-5-git-send-email-t.figa@samsung.com>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
	 <1404496099-26708-5-git-send-email-t.figa@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2014 09:27:20.0858 (UTC) FILETIME=[24D877A0:01CFA0D8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:
> All Samsung platforms are now using the Common Clock Framework and the
> legacy clock code is being removed, so remove related dead code from
> samsung-serial driver as well.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:SERIAL DRIVERS)
> Cc: Jiri Slaby <jslaby@suse.cz> (supporter:TTY LAYER)
> Cc: linux-serial@vger.kernel.org (open list:SERIAL DRIVERS)
> ---
>  drivers/tty/serial/samsung.c | 4 ----
>  1 file changed, 4 deletions(-)

This just entered linux-next (see next-20140716).

> diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
> index 36c7747..cae8ebd 100644
> --- a/drivers/tty/serial/samsung.c
> +++ b/drivers/tty/serial/samsung.c
> @@ -47,10 +47,6 @@
>  
>  #include <asm/irq.h>
>  
> -#ifdef CONFIG_SAMSUNG_CLOCK
> -#include <plat/clock.h>
> -#endif
> -
>  #include "samsung.h"
>  
>  #if	defined(CONFIG_SERIAL_SAMSUNG_DEBUG) &&	\

There are three further references to CONFIG_SAMSUNG_CLOCK in this file.
Those should be removed too, shouldn't they?


Paul  Bolle

