Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbaG3HWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:22:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbaG3HWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:22:46 -0400
Message-ID: <53D89D3F.8000309@infradead.org>
Date: Wed, 30 Jul 2014 00:22:39 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>, Wim Van Sebroeck <wim@iguana.be>
CC: Guenter Roeck <linux@roeck-us.net>, linux-watchdog@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org, again4you@gmail.com
Subject: Re: [PATCH v2] Documentation: fix two typos in watchdog-api.txt
References: <1406681781-3533-1-git-send-email-sangjung.woo@samsung.com>
In-Reply-To: <1406681781-3533-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/14 17:56, Sangjung Woo wrote:
> This patch changes 'go of' to 'go off' and 'pretimout' to
> 'pretimeout'.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  Documentation/watchdog/watchdog-api.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
> index eb7132e..b3a701f 100644
> --- a/Documentation/watchdog/watchdog-api.txt
> +++ b/Documentation/watchdog/watchdog-api.txt
> @@ -118,7 +118,7 @@ resets.
>  Note that the pretimeout is the number of seconds before the time
>  when the timeout will go off.  It is not the number of seconds until
>  the pretimeout.  So, for instance, if you set the timeout to 60 seconds
> -and the pretimeout to 10 seconds, the pretimout will go of in 50
> +and the pretimeout to 10 seconds, the pretimeout will go off in 50
>  seconds.  Setting a pretimeout to zero disables it.
>  
>  There is also a get function for getting the pretimeout:
> 


-- 
~Randy
