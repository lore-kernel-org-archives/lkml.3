Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3DZPnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:43:08 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1037 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3DZPnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:43:06 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <517AA082.8070806@broadcom.com>
Date: Fri, 26 Apr 2013 08:42:58 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Arnd Bergmann" <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "John Stultz" <john.stultz@linaro.org>
Subject: Re: [PATCH] clocksource: kona: adapt to CLOCKSOURCE_OF_DECLARE
 change
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
 <1366732475-479886-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1366732475-479886-5-git-send-email-arnd@arndb.de>
X-WSS-ID: 7D6440C91R05916295-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-04-23 08:54 AM, Arnd Bergmann wrote:
> The CLOCKSOURCE_OF_DECLARE functions now take a device_node pointer
> as their argument, as of the clksrc/cleanup branch in arm-soc.
> This patch adapts the bcm_kona_timer driver to the new interface.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Christian Daudt <csd@broadcom.com>
> Cc: John Stultz <john.stultz@linaro.org>
> ---
>   drivers/clocksource/bcm_kona_timer.c | 15 ++++-----------
>   1 file changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
> ...
>   
> -CLOCKSOURCE_OF_DECLARE(bcm_kona, "bcm,kona-timer",
> -	kona_timer_init);
> +CLOCKSOURCE_OF_DECLARE(bcm_kona, "bcm,kona-timer", kona_timer_init);
acked-by: Christian Daudt <csd@broadcom.com>
tested-by: Christian Daudt <csd@broadcom.com>

  thanks,
    csd


