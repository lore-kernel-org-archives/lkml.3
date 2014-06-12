Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbaFLIoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:44:08 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:4888 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaFLIoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:44:06 -0400
Message-ID: <53996852.1050708@free.fr>
Date: Thu, 12 Jun 2014 10:44:02 +0200
From: Guillaume Gardet <guillaume.gardet@free.fr>
Reply-To: guillaume.gardet@free.fr
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>
CC: linux-kernel@vger.kernel.org,
        openSUSE Kernel ML <opensuse-kernel@opensuse.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Girish K S <ks.giri@samsung.com>, Yuvaraj C D <yuvaraj.cd@samsung.com>,
        Jean Delvare <jdelvare@suse.de>, Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH] phy: Fix typo in drivers/phy/phy-exynos5250-sata.c module
 which fixes the build
References: <53996247.5020203@free.fr> <CAK5sBcH-6xeKomVay4PFWzLV8M-Sx=jankcE-7mj7K00=Gwe4w@mail.gmail.com>
In-Reply-To: <CAK5sBcH-6xeKomVay4PFWzLV8M-Sx=jankcE-7mj7K00=Gwe4w@mail.gmail.com>
X-Enigmail-Version: 1.6
OpenPGP: url=http://guillaume.gardet.free.fr/GPG/ClefGPGGuillaumeGardet.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 12/06/2014 10:36, Sachin Kamat a écrit :
> Hi Guillaume,
>
>
> On Thu, Jun 12, 2014 at 1:48 PM, Guillaume Gardet
> <guillaume.gardet@free.fr> wrote:
>> Hi,
>>
>> please find in attachment a patch which fixes a typo in drivers/phy/phy-exynos5250-sata.c module license.
>> It fixes the following build error:
>>     FATAL: modpost: GPL-incompatible module phy-exynos5250-sata.ko uses GPL-only symbol 'platform_driver_unregister'
>>
>> Please keep me in CC since I am not subscribed to the linux-kernel@vger.kernel.org ML.
>>
>> Signed-off-by: Guillaume GARDET <guillaume.gardet@opensuse.org>
> A similar patch has already been submitted by Arnd. Please see below:
> https://lkml.org/lkml/2014/3/15/40

Was not aware of this one. Will it be merged? I can see that it was sent 3 months ago and got no answer apparently.

>
> In general, sending an attachment is not the right way to submit a patch.
> Please refer Documentation/SubmittingPatches in the kernel source for the
> correct procedure.

Sorry, I forgot to send it inline.


Guillaume

