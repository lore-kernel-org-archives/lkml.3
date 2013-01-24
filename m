Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3AXRMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:12:20 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:57476 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3AXRMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:12:19 -0500
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 12:12:19 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2013 09:02:49 -0800
From: gg <gg@slimlogic.co.uk>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        AnilKumar Ch <anilkumar@ti.com>
Subject: Re: [PATCH 2/2] regulator: tps65910: Fix using wrong dev argument
 for calling =?UTF-8?Q?of=5Fregulator=5Fmatch?=
In-Reply-To: <5100BC87.30301@nvidia.com>
References: <1358994450.20257.1.camel@phoenix>
 <1358994705.20257.4.camel@phoenix> <5100BC87.30301@nvidia.com>
Message-ID: <51596d8c5e0ac596c9b0fa64b7bca964@slimlogic.co.uk>
User-Agent: Roundcube Webmail/0.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-23 20:45, Laxman Dewangan wrote:
> On Thursday 24 January 2013 08:01 AM, Axel Lin wrote:
>> The dev parameter is the device requesting the data.
>> In this case it should be &pdev->dev rather than pdev->dev.parent.
>>
>> The dev parameter is used to call devm_kzalloc in 
>> of_get_regulator_init_data(),
>> which means this fixes a memory leak because the memory is allocated 
>> every time
>> probe() is called, thus it should be freed when this driver is 
>> unloaded.
>>
>> Signed-off-by: Axel Lin <axel.lin@ingics.com>
>> ---
>
> Agree with the change.
> Acked-by: Laxman Dewangan<ldewangan@nvidia.com>

Also agree.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

