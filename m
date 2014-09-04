Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbaIDDrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 23:47:12 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:16398 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbaIDDrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 23:47:10 -0400
Message-ID: <5407E096.5000005@huawei.com>
Date: Thu, 4 Sep 2014 11:46:30 +0800
From: xiakaixu <xiakaixu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-arm-kernel@lists.infradead.org>
CC: Arnd Bergmann <arnd@arndb.de>, Felix Fietkau <nbd@openwrt.org>,
        <linaro-kernel@lists.linaro.org>, Anton Vorontsov <anton@enomsg.org>,
        <linux-kernel@vger.kernel.org>, Imre Kaloz <kaloz@openwrt.org>,
        Xia Kaixu <kaixu.xia@linaro.org>
Subject: Re: [PATCH] ARM: cns3xxx: fix allmodconfig panic in pci driver
References: <kaixu.xia@linaro.org> <1409750292-24105-1-git-send-email-kaixu.xia@linaro.org> <2886818.zPBP0DOepO@wuerfel>
In-Reply-To: <2886818.zPBP0DOepO@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.100.238]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020207.5407E0AB.0093,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 5ba8e73dce5fc212d5c8edbbdf856972
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/9/3 21:27, Arnd Bergmann 写道:
> On Wednesday 03 September 2014 21:18:12 Xia Kaixu wrote:
>> From: Xia Kaixu <kaixu.xia@linaro.org>
>>
>> The kernel panic occurs when running an allmodconfig kernel on 
>> OMAP4460. The inicall "cns3xxx_pcie_init" does not check which
>> hardware it's running on and just tries to access to its specific 
>> registers. Now call it from .init_late callback from the two
>> machine descriptors.
>>
>> Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: Anton Vorontsov <anton@enomsg.org>
>> Cc: Felix Fietkau <nbd@openwrt.org>
>> Cc: Imre Kaloz <kaloz@openwrt.org>
>> Cc: linaro-kernel@lists.linaro.org
>> Cc: linux-arm-kernel@lists.infradead.org
> 
> Hi Kaixu,
> 
> it seems this time all the Cc's worked. One thing I just noticed is that
> you confused the 'Signed-off-by' lines. I did look at the patch earlier
> before you sent it out but unfortunately missed that.
> 
> You can read again in Documentation/SubmittingPatches about how
> they work, but the short version is that you must never put someone
> else's name in Signed-off-by under a patch you write yourself.
> When we apply the patch, I (or whoever else does) will put that
> line below yours to document who handled the patch.

  Sure, you are right. Thanks for the reminder!
> 
> Otherwise, the patch looks good to me, thanks a lot for doing it.
> 
> 	Arnd
> 
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
> 


