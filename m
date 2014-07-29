Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaG2Qrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:47:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:38546 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaG2Qrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:47:47 -0400
Message-ID: <53D7D02D.6010508@infradead.org>
Date: Tue, 29 Jul 2014 09:47:41 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sangjung Woo <sangjung.woo@samsung.com>, Wim Van Sebroeck <wim@iguana.be>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        again4you@gmail.com, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Documentation: fix a typo in watchdog-api.txt
References: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com>
In-Reply-To: <1406621064-5466-1-git-send-email-sangjung.woo@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/14 01:04, Sangjung Woo wrote:
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> ---
>  Documentation/watchdog/watchdog-api.txt |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/watchdog/watchdog-api.txt b/Documentation/watchdog/watchdog-api.txt
> index eb7132e..53c49a4 100644
> --- a/Documentation/watchdog/watchdog-api.txt
> +++ b/Documentation/watchdog/watchdog-api.txt
> @@ -118,7 +118,7 @@ resets.
>  Note that the pretimeout is the number of seconds before the time
>  when the timeout will go off.  It is not the number of seconds until
>  the pretimeout.  So, for instance, if you set the timeout to 60 seconds
> -and the pretimeout to 10 seconds, the pretimout will go of in 50
> +and the pretimeout to 10 seconds, the pretimout will go off in 50

                                         pretimeout

Please correct that word also and then resend.  Also resend to:
trivial@kernel.org

Thanks.

>  seconds.  Setting a pretimeout to zero disables it.
>  
>  There is also a get function for getting the pretimeout:
> 


-- 
~Randy
