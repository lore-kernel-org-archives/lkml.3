Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJRCbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 22:31:50 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34013 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJRCbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 22:31:49 -0400
Message-ID: <5441D110.5080808@roeck-us.net>
Date: Fri, 17 Oct 2014 19:31:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH] i8k: Add MODULE_DEVICE_TABLE macro
References: <1413584269-19014-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1413584269-19014-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5441D114.011D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 10/17/2014 03:17 PM, Pali Rohár wrote:
> This patch adds MODULE_DEVICE_TABLE macro so i8k.ko module can be automatically
> loaded based on dmi system alias.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/char/i8k.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 471f985..7272b08 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -796,6 +796,8 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>   	{ }
>   };
>
> +MODULE_DEVICE_TABLE(dmi, i8k_dmi_table);
> +
>   /*
>    * Probe for the presence of a supported laptop.
>    */
>

