Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab3JWNr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:47:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33520 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751363Ab3JWNr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:47:56 -0400
Message-ID: <5267D386.4050206@hurleysoftware.com>
Date: Wed, 23 Oct 2013 09:47:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        jhovold@gmail.com
Subject: Re: [PATCH] tty: Add C_MSPAR(tty)
References: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
In-Reply-To: <1382527101-30473-1-git-send-email-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 07:18 AM, Andrew Lunn wrote:
> Add the missing C_MSPAR(tty) macro.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>   include/linux/tty.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index 64f8646..630678d 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -137,6 +137,7 @@ struct tty_bufhead {
>   #define C_CLOCAL(tty)	_C_FLAG((tty), CLOCAL)
>   #define C_CIBAUD(tty)	_C_FLAG((tty), CIBAUD)
>   #define C_CRTSCTS(tty)	_C_FLAG((tty), CRTSCTS)
> +#define C_MSPAR(tty)	_C_FLAG((tty), CMSPAR)
>
>   #define L_ISIG(tty)	_L_FLAG((tty), ISIG)
>   #define L_ICANON(tty)	_L_FLAG((tty), ICANON)

Is this to support an out-of-tree driver?

Regards,
Peter Hurley
