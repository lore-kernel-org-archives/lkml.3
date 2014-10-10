Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaJJU5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:57:06 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:51531 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaJJU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:57:04 -0400
Message-ID: <54384817.6060102@roeck-us.net>
Date: Fri, 10 Oct 2014 13:56:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH] i8k: Add support for Dell Latitude E6440
References: <1412932368-24082-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1412932368-24082-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.5438481E.0144,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
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

On 10/10/2014 02:12 AM, Pali Rohár wrote:
> Dell Latitude E6440 needs same settings as E6540.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   drivers/char/i8k.c |    8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
> index 34174d0..471f985 100644
> --- a/drivers/char/i8k.c
> +++ b/drivers/char/i8k.c
> @@ -711,6 +711,14 @@ static struct dmi_system_id i8k_dmi_table[] __initdata = {
>   		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_D520],
>   	},
>   	{
> +		.ident = "Dell Latitude E6440",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6440"),
> +		},
> +		.driver_data = (void *)&i8k_config_data[DELL_LATITUDE_E6540],
> +	},
> +	{
>   		.ident = "Dell Latitude E6540",
>   		.matches = {
>   			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
>

