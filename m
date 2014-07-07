Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGGDPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:15:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37902 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaGGDPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:15:50 -0400
Message-ID: <53BA10D2.7080409@hisilicon.com>
Date: Mon, 7 Jul 2014 11:15:30 +0800
From: xuwei <xuwei5@hisilicon.com>
Organization: hisilicon
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Li Zefan <lizefan@huawei.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] MAINTAINERS:ARM:hisi: add Hisilicon SoC family
References: <53B66A9F.6040404@hisilicon.com> <53B6A41D.1030000@cogentembedded.com>
In-Reply-To: <53B6A41D.1030000@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.75.104]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/7/4 20:54, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/04/2014 12:49 PM, xuwei wrote:
> 
>> Introduce a new mach-hisi that will support Hisilicon SoCs based on ARMv7
>> and I am taking maintainership for it.
> 
>> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
>> ---
>>   MAINTAINERS | 8 ++++++++
>>   1 file changed, 8 insertions(+)
> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 134483f..a4f700a 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -972,6 +972,14 @@ F:    arch/arm/mach-pxa/hx4700.c
>>   F:    arch/arm/mach-pxa/include/mach/hx4700.h
>>   F:    sound/soc/pxa/hx4700.c
>>
>> +ARM/Hisilicon SoC support
> 
>    This line is traditionally written in upper case.

Hi Sergei,

Thanks!
I will change it to upper case. 

>> +M:    Wei Xu <xuwei5@hisilicon.com>
>> +L:    linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>> +W:    www.hisilicon.com
> 
>    How about http://?

will add it.

Best Regards,
Wei

> 
>> +S:    Supported
>> +T:    git git://github.com/hisilicon/linux-hisi.git
>> +F:    arch/arm/mach-hisi/
>> +
> 
> WBR, Sergei
> 
> 
> 

