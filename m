Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaJPNS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:18:59 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:38615 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJPNS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:18:57 -0400
Message-ID: <543FC5BB.6050106@roeck-us.net>
Date: Thu, 16 Oct 2014 06:18:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Johannes Thumshirn <johannes.thumshirn@men.de>,
        Andreas Werner <andreas.werner@men.de>,
        Jean Delvare <jdelvare@suse.de>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: menf21bmc: Include linux/err.h
References: <1413464871-882-1-git-send-email-johannes.thumshirn@men.de>
In-Reply-To: <1413464871-882-1-git-send-email-johannes.thumshirn@men.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.543FC5C1.00AD,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 06:07 AM, Johannes Thumshirn wrote:
> Include linux/err.h to get the definitions for IS_ERR() PTR_ERR() and
> ERR_PTR() used in the driver.
>
> This fixes compilation on powerpc targets.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>

Hmm, my build tests should really find that :-(

Applied, thanks

Guenter

> ---
>   drivers/hwmon/menf21bmc_hwmon.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/hwmon/menf21bmc_hwmon.c b/drivers/hwmon/menf21bmc_hwmon.c
> index c92229d..afc6b58 100644
> --- a/drivers/hwmon/menf21bmc_hwmon.c
> +++ b/drivers/hwmon/menf21bmc_hwmon.c
> @@ -21,6 +21,7 @@
>   #include <linux/jiffies.h>
>   #include <linux/slab.h>
>   #include <linux/i2c.h>
> +#include <linux/err.h>
>
>   #define DRV_NAME  "menf21bmc_hwmon"
>
>

