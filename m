Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3AYBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:16:29 -0500
Received: from mail.lemote.com ([222.92.8.141]:55802 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3AYBQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:16:23 -0500
X-Greylist: delayed 638 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2013 20:16:23 EST
Message-ID: <2658.219.143.8.242.1359072905.squirrel@mail.lemote.com>
Date: Fri, 25 Jan 2013 08:15:05 +0800 (CST)
Subject: Re: [PATCH V8 00/13] MIPS: Add Loongson-3 based machines support
From: =?gb2312?Q?=B3=C2=BB=AA=B2=C5?= <chenhc@lemote.com>
To: "John Crispin" <john@phrozen.org>
Cc: "Ralf Baechle" <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, "Fuxin Zhang" <zhangfx@lemote.com>,
        "Zhangjin Wu" <wuzhangjin@gmail.com>,
        "Hongliang Tao" <taohl@lemote.com>, "Hua Yan" <yanh@lemote.com>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ok, I'll prepare v9 of this seris in these days.
>
>>
>> Huacai Chen(13):
>>   MIPS: Loongson: Add basic Loongson-3 definition.
>>   MIPS: Loongson: Add basic Loongson-3 CPU support.
>>   MIPS: Loongson: Introduce and use cpu_has_coherent_cache feature.
>>   MIPS: Loongson 3: Add Lemote-3A machtypes definition.
>>   MIPS: Loongson: Add UEFI-like firmware interface support.
>>   MIPS: Loongson 3: Add HT-linked PCI support.
>>   MIPS: Loongson 3: Add IRQ init and dispatch support.
>>   MIPS: Loongson 3: Add serial port support.
>>   MIPS: Loongson: Add swiotlb to support big memory (>4GB).
>>   MIPS: Loongson: Add Loongson-3 Kconfig options.
>>   MIPS: Loongson 3: Add Loongson-3 SMP support.
>>   MIPS: Loongson 3: Add CPU hotplug support.
>>   MIPS: Loongson: Add a Loongson-3 default config file.
>>
>> Signed-off-by: Huacai Chen<chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao<taohl@lemote.com>
>> Signed-off-by: Hua Yan<yanh@lemote.com>
>> ---
>
> Hi,
>
> I have added all patches apart from 3/13 to my queue.
>
> I believe "MIPS: Loongson: Introduce and use cpu_has_coherent_cache
> feature." should e rewritten in a saner way.
>
> Please compile and runtime test the tree before I send it to Ralf
> -->
> http://git.linux-mips.org/?p=john/linux-john.git;a=shortlog;h=refs/heads/mips-next-3.9
>
> I cleaned up a few minor whitespace errors while merging.
>
> http://patchwork.linux-mips.org/patch/4547/ has a few comments. Please
> prepare a patch asap to address those so i can fold it into the series.
>
> 	John
>


-- 
江苏中科梦兰电子科技有限公司

软件部 陈华才

E-mail: chenhc@lemote.com

Web: http://www.lemote.com/

Add: 江苏省常熟市虞山镇梦兰工业园

