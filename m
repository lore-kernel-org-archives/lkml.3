Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaGNCOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 22:14:49 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:47874
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752194AbaGNCOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 22:14:43 -0400
Message-ID: <53C33DC7.1020500@freescale.com>
Date: Mon, 14 Jul 2014 10:17:43 +0800
From: Liu Ying <Ying.Liu@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] drivers/base: redundant return value settings in try_to_bring_up_master()
References: <1402993531-25244-1-git-send-email-Ying.Liu@freescale.com>
 <20140712005840.GA10558@kroah.com>
In-Reply-To: <20140712005840.GA10558@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(479174003)(377454003)(24454002)(199002)(189002)(51704005)(15975445006)(79102001)(59896001)(36756003)(46102001)(19580395003)(64126003)(83506001)(23756003)(83322001)(92726001)(106466001)(80022001)(92566001)(85852003)(65956001)(86362001)(83072002)(102836001)(76176999)(74502001)(104016003)(65806001)(110136001)(81542001)(87936001)(19580405001)(85306003)(80316001)(4396001)(20776003)(26826002)(65816999)(47776003)(81342001)(97736001)(105606002)(74662001)(21056001)(44976005)(76482001)(50986999)(6806004)(68736004)(87266999)(99396002)(77982001)(31966008)(64706001)(107046002)(95666004)(54356999)(50466002)(33656002)(84676001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB378;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 08:58 AM, Greg KH wrote:
> On Tue, Jun 17, 2014 at 04:25:31PM +0800, Liu Ying wrote:
>> Remove redundant return value settings 'ret = 0;' in the function
>> try_to_bring_up_master(), since it has already been set to zero.
>>
>> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
>> ---
>>   drivers/base/component.c |    2 --
>>   1 file changed, 2 deletions(-)
>
> This patch no longer applies to my tree, are you sure it's still needed?

It is no longer needed, because Russell's patch[1] on your tree changed 
this piece of code.

[1] 
https://git.kernel.org/cgit/linux/kernel/git/gregkh/driver-core.git/commit/drivers/base/component.c?h=driver-core-next&id=c334940ea26cb58f5514dcbb225a3f397b2684ad

Regards,

Liu Ying

>
> If so, please refresh and resend.
>
> thanks,
>
> greg k-h
>
