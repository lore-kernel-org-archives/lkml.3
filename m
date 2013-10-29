Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3J2SRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:17:54 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57757 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3J2SRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:17:52 -0400
Date: Tue, 29 Oct 2013 19:17:46 +0100
From: Johan Hovold <jhovold@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: peter@hurleysoftware.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, jhovold@gmail.com
Subject: Re: [PATCH] tty: Add C_MSPAR(tty)
Message-ID: <20131029181746.GE29615@localhost>
References: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 01:18:21PM +0200, Andrew Lunn wrote:
> Add the missing C_MSPAR(tty) macro.

Please rename the macro C_CMSPAR to be consistent with the other
termios-flag macros (with C_BAUD being the exception that confirms the
rule).

Thanks,
Johan

> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/linux/tty.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 64f8646..630678d 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -137,6 +137,7 @@ struct tty_bufhead {
>  #define C_CLOCAL(tty)	_C_FLAG((tty), CLOCAL)
>  #define C_CIBAUD(tty)	_C_FLAG((tty), CIBAUD)
>  #define C_CRTSCTS(tty)	_C_FLAG((tty), CRTSCTS)
> +#define C_MSPAR(tty)	_C_FLAG((tty), CMSPAR)
>  
>  #define L_ISIG(tty)	_L_FLAG((tty), ISIG)
>  #define L_ICANON(tty)	_L_FLAG((tty), ICANON)
> -- 
> 1.8.4.rc3
> 
