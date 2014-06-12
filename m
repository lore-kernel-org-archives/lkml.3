Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009AbaFLJtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:49:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35127 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbaFLJtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:49:08 -0400
Message-ID: <5399777A.8020900@ti.com>
Date: Thu, 12 Jun 2014 15:18:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <guillaume.gardet@free.fr>, Sachin Kamat <sachin.kamat@samsung.com>
CC: <linux-kernel@vger.kernel.org>,
        openSUSE Kernel ML <opensuse-kernel@opensuse.org>,
        Girish K S <ks.giri@samsung.com>, Yuvaraj C D <yuvaraj.cd@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH] phy: Fix typo in drivers/phy/phy-exynos5250-sata.c module
 which fixes the build
References: <53996247.5020203@free.fr> <CAK5sBcH-6xeKomVay4PFWzLV8M-Sx=jankcE-7mj7K00=Gwe4w@mail.gmail.com> <53996852.1050708@free.fr> <53996CF9.5070100@ti.com> <53997666.7000003@free.fr>
In-Reply-To: <53997666.7000003@free.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday 12 June 2014 03:14 PM, Guillaume Gardet wrote:
> 
> Le 12/06/2014 11:03, Kishon Vijay Abraham I a écrit :
>>
>> On Thursday 12 June 2014 02:14 PM, Guillaume Gardet wrote:
>>> Le 12/06/2014 10:36, Sachin Kamat a écrit :
>>>> Hi Guillaume,
>>>>
>>>>
>>>> On Thu, Jun 12, 2014 at 1:48 PM, Guillaume Gardet
>>>> <guillaume.gardet@free.fr> wrote:
>>>>> Hi,
>>>>>
>>>>> please find in attachment a patch which fixes a typo in drivers/phy/phy-exynos5250-sata.c module license.
>>>>> It fixes the following build error:
>>>>>     FATAL: modpost: GPL-incompatible module phy-exynos5250-sata.ko uses GPL-only symbol 'platform_driver_unregister'
>>>>>
>>>>> Please keep me in CC since I am not subscribed to the linux-kernel@vger.kernel.org ML.
>>>>>
>>>>> Signed-off-by: Guillaume GARDET <guillaume.gardet@opensuse.org>
>>>> A similar patch has already been submitted by Arnd. Please see below:
>>>> https://lkml.org/lkml/2014/3/15/40
>>> Was not aware of this one. Will it be merged? I can see that it was sent 3 months ago and got no answer apparently.
>> It's in mainline kernel already
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/phy/phy-exynos5250-sata.c?id=fe04e4297e6eab014a2cf152319b9f361df07faf
> 
> Ok. It is in mainline but not in 3.15.

hmm, yes. It went in this merge window.

-Kishon

> 
> 
> Guillaume
> 
