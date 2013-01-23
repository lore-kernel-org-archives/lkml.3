Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3AWIKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:10:03 -0500
Received: from mail.bachmann.info ([213.33.91.3]:36639 "EHLO
	mail.bachmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3AWIKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:10:00 -0500
X-Greylist: delayed 983 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jan 2013 03:10:00 EST
From: "GMEINER.Christian" <C.GMEINER@bachmann.info>
To: Christian Gmeiner <christian.gmeiner@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH] leds-ot200: Fix error caused by shifted mask
Thread-Topic: [PATCH] leds-ot200: Fix error caused by shifted mask
Thread-Index: AQHN+T48/idtyqfQu0Kd9gLfZi0sQ5hWigmg
Date: Wed, 23 Jan 2013 07:53:23 +0000
Message-ID: <7AFBFD79B857054D97821A9BD3FBFA9744D05BD2@ATFKEX06.bachmann.at>
References: <1358928657-15781-1-git-send-email-christian.gmeiner@gmail.com>
In-Reply-To: <1358928657-15781-1-git-send-email-christian.gmeiner@gmail.com>
Accept-Language: de-AT, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.120.16]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Ursprüngliche Nachricht-----
> Von: Christian Gmeiner [mailto:christian.gmeiner@gmail.com]
> Gesendet: Mittwoch, 23. Januar 2013 09:11
> An: linux-next@vger.kernel.org; akpm@linux-foundation.org;
> rpurdie@rpsys.net; linux-kernel@vger.kernel.org; GMEINER.Christian
> Cc: Christian Gmeiner
> Betreff: [PATCH] leds-ot200: Fix error caused by shifted mask
> 
> During the development of this driver an in-house register documentation
> was used. The last weeks some integration tests were done and this problem
> was found. It turned out that the released register documentation is wrong.
> 
> The fix is very simple: shift all masks by one.
> 
> Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>


Acked-by: Christian Gmeiner <c.gmeiner@bachmann.info>
Tested-by: Christian Gmeiner <c.gmeiner@bachmann.info>

> ---
>  drivers/leds/leds-ot200.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/leds/leds-ot200.c b/drivers/leds/leds-ot200.c index
> ee14662..98cae52 100644
> --- a/drivers/leds/leds-ot200.c
> +++ b/drivers/leds/leds-ot200.c
> @@ -47,37 +47,37 @@ static struct ot200_led leds[] = {
>  	{
>  		.name = "led_1",
>  		.port = 0x49,
> -		.mask = BIT(7),
> +		.mask = BIT(6),
>  	},
>  	{
>  		.name = "led_2",
>  		.port = 0x49,
> -		.mask = BIT(6),
> +		.mask = BIT(5),
>  	},
>  	{
>  		.name = "led_3",
>  		.port = 0x49,
> -		.mask = BIT(5),
> +		.mask = BIT(4),
>  	},
>  	{
>  		.name = "led_4",
>  		.port = 0x49,
> -		.mask = BIT(4),
> +		.mask = BIT(3),
>  	},
>  	{
>  		.name = "led_5",
>  		.port = 0x49,
> -		.mask = BIT(3),
> +		.mask = BIT(2),
>  	},
>  	{
>  		.name = "led_6",
>  		.port = 0x49,
> -		.mask = BIT(2),
> +		.mask = BIT(1),
>  	},
>  	{
>  		.name = "led_7",
>  		.port = 0x49,
> -		.mask = BIT(1),
> +		.mask = BIT(0),
>  	}
>  };
> 
> --
> 1.7.12.2.421.g261b511

