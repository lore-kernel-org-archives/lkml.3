Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3GPG5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:57:55 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56363 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab3GPG5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:57:54 -0400
Message-ID: <51E4EEEA.4000208@cypress.com>
Date: Tue, 16 Jul 2013 09:57:46 +0300
From: Ferruh Yigit <fery@cypress.com>
Organization: Cypress
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@dowhile0.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, ttdrivers@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] MAINTAINERS: Change maintainer for cyttsp driver
References: <1373838082-12372-1-git-send-email-javier@dowhile0.org> <1373838082-12372-2-git-send-email-javier@dowhile0.org>
In-Reply-To: <1373838082-12372-2-git-send-email-javier@dowhile0.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2013 12:41 AM, Javier Martinez Canillas wrote:
> I haven't had time to work on this driver for a long time and
> Ferruh has been doing a great job making it more generic,
> adding support for new hardware and providing bug fixes.
Thank you a lot for your work on cyttsp drivers,
we would like to see your support back whenever you have time again.
Your expertise/know-how on issue is valuable.

>
> So, let's make MAINTAINERS reflect reality and add him as the
> cyttsp maintainer instead of me.
>
> Also, since Ferruh works for Cypress, we may change the driver
> status from Maintained to Supported.
>
> Signed-off-by: Javier Martinez Canillas <javier@dowhile0.org>
> ---
>
> Ferruh, please send your ack if you are willing to take over
> maintainance of this driver.

Acked-by: Ferruh Yigit <fery@cypress.com>

>
> Also, please confirm that you have been working on behalf of
> Cypress instead of doing it on your free time. Otherwise we
> should keep the driver status to maintained instead supported.
Right, I am a Cypress employee and working on TrueTouch drivers.
>
> Thanks a lot and best regards,
> Javier
>
>   MAINTAINERS |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9d771d9..4ba996c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2458,9 +2458,9 @@ S:	Maintained
>   F:	drivers/media/common/cypress_firmware*
>   
>   CYTTSP TOUCHSCREEN DRIVER
> -M:	Javier Martinez Canillas <javier@dowhile0.org>
> +M:	Ferruh Yigit <fery@cypress.com>
>   L:	linux-input@vger.kernel.org
> -S:	Maintained
> +S:	Supported
>   F:	drivers/input/touchscreen/cyttsp*
>   F:	include/linux/input/cyttsp.h
>   


-- 

Regards,
ferruh

