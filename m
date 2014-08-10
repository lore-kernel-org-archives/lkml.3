Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaHJSmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 14:42:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62124 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaHJSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 14:42:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E7BD21.6010301@roeck-us.net>
Date: Sun, 10 Aug 2014 11:42:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Li Yang <leoli@freescale.com>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ugg_geth: Fix build error in -next
References: <1407687554-14539-1-git-send-email-linux@roeck-us.net> <20140810183622.GC5134@pengutronix.de>
In-Reply-To: <20140810183622.GC5134@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2014 11:36 AM, Uwe Kleine-König wrote:
> Hello Guenter,
>
> On Sun, Aug 10, 2014 at 09:19:14AM -0700, Guenter Roeck wrote:
>> powerpc:mpc83xx_defconfig and other builds fail with
>>
>> drivers/net/ethernet/freescale/ucc_geth.c: In function 'ucc_geth_remove':
>> drivers/net/ethernet/freescale/ucc_geth.c:3927:19: error:
>> 	'struct ucc_geth_private' has no member named 'info'
>>    of_node_put(ugeth->info->tbi_node);
>>                       ^
>> drivers/net/ethernet/freescale/ucc_geth.c:3928:19: error:
>> 	     'struct ucc_geth_private' has no member named 'info'
>>    of_node_put(ugeth->info->phy_node);
>>    		     ^
>>
>> Introduced by commit "net: ucc_geth: drop acquired references in probe error
>> path and remove".
>>
>>  From the context, it appears that the variable is named ug_info.
>>
>> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> Only seen in -next.
> My patch was only sent just now, but it has the subject right:
>
Excellent.

> 	http://mid.gmane.org/1407695525-32227-1-git-send-email-u.kleine-koenig@pengutronix.de
>
The link doesn't seem to work for some reason.

> Another upside is that it contains a Fixes: header.
>
Even better. I need to start using that.

> Other than that my patch is the same. In case davem picks up yours:
>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>

I don't need the glory ;-). Dave, please pick Uwe's patch.

Thanks,
Guenter

