Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaBCJN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:13:56 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750779AbaBCJNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:13:53 -0500
Message-ID: <52EF5DCA.3060506@nod.at>
Date: Mon, 03 Feb 2014 10:13:46 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog,dw: Add dependency on HAS_IOMEM
References: <1391172454-17959-1-git-send-email-richard@nod.at> <20140203085800.GC29278@spo001.leaseweb.com>
In-Reply-To: <20140203085800.GC29278@spo001.leaseweb.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.02.2014 09:58, schrieb Wim Van Sebroeck:
> Hi Richard,
> 
>> On archs like S390 or um this driver cannot build nor work.
>> Make it depend on HAS_IOMEM to bypass build failures.
>>
>> drivers/built-in.o: In function `dw_wdt_drv_probe':
>> drivers/watchdog/dw_wdt.c:302: undefined reference to `devm_ioremap_resource'
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Patch added to linux-watchdog-next.

-next in terms of 3.15 material?
Please push this as soon as possible to Linus such that the build works on said archs.

Thanks,
//richard
