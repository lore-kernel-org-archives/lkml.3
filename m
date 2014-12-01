Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaLALeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:34:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbaLALe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:34:29 -0500
Date: Mon, 1 Dec 2014 12:34:24 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/3] MAINTAINERS: Fix up entry for Dell
 laptop SMM driver
Message-ID: <20141201123424.63c01f7a@endymion.delvare>
In-Reply-To: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Nov 2014 13:00:38 -0800, Guenter Roeck wrote:
> Mark driver as maintained.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ff630d..a67e223 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2918,6 +2918,7 @@ F:	drivers/platform/x86/dell-laptop.c
>  
>  DELL LAPTOP SMM DRIVER
>  M:	Guenter Roeck <linux@roeck-us.net>
> +S:	Maintained
>  F:	drivers/char/i8k.c
>  F:	include/uapi/linux/i8k.h
>  

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
SUSE L3 Support
