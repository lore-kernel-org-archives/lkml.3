Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaEIFPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 01:15:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40101 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbaEIFPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 01:15:41 -0400
Message-ID: <536C6465.6060907@ti.com>
Date: Fri, 9 May 2014 10:45:17 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yuval Mintz <Yuval.Mintz@qlogic.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
CC: David Miller <davem@davemloft.net>,
        "mugunthanvnm@ti.com" <mugunthanvnm@ti.com>,
        "balbi@ti.com" <balbi@ti.com>, "zonque@gmail.com" <zonque@gmail.com>,
        "mpa@pengutronix.de" <mpa@pengutronix.de>,
        "tklauser@distanz.ch" <tklauser@distanz.ch>
Subject: Re: [PATCH v2 2/3] net: davinci_mdio: Convert pr_err() to dev_err()
 call
References: <1399542652-14900-1-git-send-email-george.cherian@ti.com> <1399542652-14900-3-git-send-email-george.cherian@ti.com> <B5657A6538887040AD3A81F1008BEC63AD20DC@avmb3.qlogic.org>
In-Reply-To: <B5657A6538887040AD3A81F1008BEC63AD20DC@avmb3.qlogic.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/2014 10:20 PM, Yuval Mintz wrote:
>> Also, Convert kzalloc to devm_kzalloc.
> Looks like you should remove this part of the comment.
Ah... Missed to update the commit log after rebasing patch to net-next.
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> Reviewed-by: Felipe Balbi <balbi@ti.com>
>> ---
>>   drivers/net/ethernet/ti/davinci_mdio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c
>> b/drivers/net/ethernet/ti/davinci_mdio.c
>> index 34e97ec..735dc53 100644
>> --- a/drivers/net/ethernet/ti/davinci_mdio.c
>> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
>> @@ -303,7 +303,7 @@ static int davinci_mdio_probe_dt(struct
>> mdio_platform_data *data,
>>                return -EINVAL;
>>
>>        if (of_property_read_u32(node, "bus_freq", &prop)) {
>> -             pr_err("Missing bus_freq property in the DT.\n");
>> +             dev_err(&pdev->dev, "Missing bus_freq property in the DT.\n");
>>                return -EINVAL;
>>        }
>>        data->bus_freq = prop;
> ________________________________
>
> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.


-- 
-George

