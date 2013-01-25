Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431Ab3AYG2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:28:18 -0500
Received: from nbd.name ([46.4.11.11]:53539 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab3AYG2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:28:14 -0500
Message-ID: <51022564.1090109@phrozen.org>
Date: Fri, 25 Jan 2013 07:25:40 +0100
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: =?GB2312?B?s8K7qrLF?= <chenhc@lemote.com>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: Re: [PATCH V8 00/13] MIPS: Add Loongson-3 based machines support
References: <2658.219.143.8.242.1359072905.squirrel@mail.lemote.com>
In-Reply-To: <2658.219.143.8.242.1359072905.squirrel@mail.lemote.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/01/13 01:15, ³Â»ª²Å wrote:
> ok, I'll prepare v9 of this seris in these days.
>>


Please dont send v9

read my mail and compile / runtime test the tree please

only patch 3 needs to be reworked and an update for the "MIPS: Loongson
3: Add HT-linked PCI support." needs to e made

	John

>>>
>>> Huacai Chen(13):
>>>    MIPS: Loongson: Add basic Loongson-3 definition.
>>>    MIPS: Loongson: Add basic Loongson-3 CPU support.
>>>    MIPS: Loongson: Introduce and use cpu_has_coherent_cache feature.
>>>    MIPS: Loongson 3: Add Lemote-3A machtypes definition.
>>>    MIPS: Loongson: Add UEFI-like firmware interface support.
>>>    MIPS: Loongson 3: Add HT-linked PCI support.
>>>    MIPS: Loongson 3: Add IRQ init and dispatch support.
>>>    MIPS: Loongson 3: Add serial port support.
>>>    MIPS: Loongson: Add swiotlb to support big memory (>4GB).
>>>    MIPS: Loongson: Add Loongson-3 Kconfig options.
>>>    MIPS: Loongson 3: Add Loongson-3 SMP support.
>>>    MIPS: Loongson 3: Add CPU hotplug support.
>>>    MIPS: Loongson: Add a Loongson-3 default config file.
>>>
>>> Signed-off-by: Huacai Chen<chenhc@lemote.com>
>>> Signed-off-by: Hongliang Tao<taohl@lemote.com>
>>> Signed-off-by: Hua Yan<yanh@lemote.com>
>>> ---
>>
>> Hi,
>>
>> I have added all patches apart from 3/13 to my queue.
>>
>> I believe "MIPS: Loongson: Introduce and use cpu_has_coherent_cache
>> feature." should e rewritten in a saner way.
>>
>> Please compile and runtime test the tree before I send it to Ralf
>> -->
>> http://git.linux-mips.org/?p=john/linux-john.git;a=shortlog;h=refs/heads/mips-next-3.9
>>
>> I cleaned up a few minor whitespace errors while merging.
>>
>> http://patchwork.linux-mips.org/patch/4547/ has a few comments. Please
>> prepare a patch asap to address those so i can fold it into the series.
>>
>> 	John
>>
> 
> 

