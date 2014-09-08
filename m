Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaIHNCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:02:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaIHNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:02:07 -0400
Message-ID: <540DA8AB.3060008@canonical.com>
Date: Mon, 08 Sep 2014 15:01:31 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt@console-pimps.org>
CC: Michael Brown <mbrown@fensystems.co.uk>, Ulf Winkelvos <ulf@winkelvos.de>,
        Matt Fleming <matt.fleming@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [REGRESSION] "efi: efistub: Convert into static library" and
 preparation patches
References: <CAKv+Gu8OD3p+GSwB+SPRf3pKwZB2R1t6x1zK7czGCXj1QhB7_g@mail.gmail.com>	<54073409.6030004@canonical.com>	<CAKv+Gu9q1qTh6DZXsCG2tGVBn-uwuQKQa_6FEMmchDVFi5vJtw@mail.gmail.com>	<20140903175948.GH3001@console-pimps.org>	<CAKv+Gu9tejixb3Kb3YM_7sLcpKNuRHN+Dn+twFyCAXx99wYRCw@mail.gmail.com>	<54084376.8090002@canonical.com>	<540860F1.6060801@fensystems.co.uk>	<CAKv+Gu8wALTqtNQK_855A7M5f2a+EB1JyLxo=j6G0T1cf8ZFog@mail.gmail.com>	<CAKv+Gu_sLmkBHF-9GyPUgfAbLYirQTD4vk63o6HzdZhm6s_e0g@mail.gmail.com>	<20140904213753.GM3001@console-pimps.org>	<20140905202744.GO3001@console-pimps.org> <CAKv+Gu8GOHMa=zVWBG7OdSG2i2Ag_XyEBE5NzU6ffLNP8zA3Ug@mail.gmail.com>
In-Reply-To: <CAKv+Gu8GOHMa=zVWBG7OdSG2i2Ag_XyEBE5NzU6ffLNP8zA3Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 08-09-14 om 14:55 schreef Ard Biesheuvel:
> On 5 September 2014 22:27, Matt Fleming <matt@console-pimps.org> wrote:
>> On Thu, 04 Sep, at 10:37:53PM, Matt Fleming wrote:
>>> Thanks Ard, I'll take a look in the morning.
>> Maarten, could you try out this patch?
>>
> Any developments regarding this patch?
> I tried to test it myself, but my Macbook happily boots straight from
> EFI into the kernel without it.
Sorry, forgot about it.

My system boots fine with this patch, thanks!

~Maarten
