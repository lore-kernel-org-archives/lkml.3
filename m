Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbaJaNLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:11:10 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:38999 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJaNLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:11:08 -0400
Message-ID: <54538A5C.7000204@roeck-us.net>
Date: Fri, 31 Oct 2014 06:10:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        neelegup@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] hwmon: (ibmpowernv) Make the driver name more recognisable
References: <1414737923-8227-1-git-send-email-mpe@ellerman.id.au> <1414737923-8227-2-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1414737923-8227-2-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54538A61.02E8,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
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

On 10/30/2014 11:45 PM, Michael Ellerman wrote:
> Seeing "ibmpowernv" in dmesg is not very useful, that is just the name
> of the platform and doesn't identify the message as coming from the
> hwmon driver.
>
> Change DRVNAME to "powernv-hwmon" to make it clearer.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>   drivers/hwmon/ibmpowernv.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/hwmon/ibmpowernv.c b/drivers/hwmon/ibmpowernv.c
> index 6a30eeea94be..3ee00928cda9 100644
> --- a/drivers/hwmon/ibmpowernv.c
> +++ b/drivers/hwmon/ibmpowernv.c
> @@ -16,7 +16,7 @@
>    * along with this program.
>    */
>
> -#define DRVNAME		"ibmpowernv"
> +#define DRVNAME		"powernv-hwmon"
>   #define pr_fmt(fmt)	DRVNAME ": " fmt
>
>   #include <linux/init.h>
>
That results in a sensor name that includes "hwmon" and a dash.
The first doesn't make sense, the second is illegal and will be
rejected by the hwmon subsystem.

Nack.

Guenter

