Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaAWFVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:21:24 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:47725 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWFVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:21:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140122122653.GA15937@n2100.arm.linux.org.uk>
References: <CA+V-a8vcvTRpP-cE6SKd1KgWgzSbOXvSNW+5Jh8wqOfr1za4SQ@mail.gmail.com>
 <CA+V-a8uy6wM8nS993VeezJGOaoqM5GRsJE7FrKe7=bhD6nZhXw@mail.gmail.com> <20140122122653.GA15937@n2100.arm.linux.org.uk>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 Jan 2014 10:51:01 +0530
Message-ID: <CA+V-a8uOZojF0X-9xXOm8ji+-zMy7zJgzHBSEtG5b=Ss0WTYZg@mail.gmail.com>
Subject: Re: Kconfig errors
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 5:56 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jan 22, 2014 at 05:54:29PM +0530, Prabhakar Lad wrote:
>> Hi Russell,
>>
>> On Fri, Jan 17, 2014 at 1:07 PM, Prabhakar Lad
>> <prabhakar.csengg@gmail.com> wrote:
>> > Hi,
>> >
>> > On Linux-next branch I see following errors for davinci_all_defconfig
>> > & da8xx_omapl_defconfig configs,
>> >
>> > arch/arm/Kconfig:1966:error: recursive dependency detected!
>> > arch/arm/Kconfig:1966:    symbol ZBOOT_ROM depends on AUTO_ZRELADDR
>> > arch/arm/Kconfig:2154:    symbol AUTO_ZRELADDR is selected by ZBOOT_ROM
>> > #
>> > # configuration written to .config
>> > #
>> >
>> I am seeing this errors on linux-next, with your recent patch,
>> "[PATCH] Fix select-induced Kconfig warning for ZBOOT_ROM"
>> and strangely I see that AUTO_ZRELADDR doesnt select ZBOOT_ROM
>> but still an error.
>>
>> Note: For the davinci configs CONFIG_AUTO_ZRELADDR is not set and
>> CONFIG_ZBOOT_ROM_TEXT=0x0, CONFIG_ZBOOT_ROM_BSS=0x0
>
> I've killed off the "select AUTO_ZRELADDR if !ZBOOT_ROM" in the IMX
> Kconfig now, so when linux-next picks up my tree, that should be gone.
>
Thanks that helps.

Regards,
--Prabhakar Lad
