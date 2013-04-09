Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762678Ab3DIFYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:24:20 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:34810 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3DIFYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:24:18 -0400
MIME-Version: 1.0
In-Reply-To: <237c01ce2f8c$92eb8ac0$b8c2a040$%kim@samsung.com>
References: <1364297642-2746-1-git-send-email-amit.daniel@samsung.com>
	<237c01ce2f8c$92eb8ac0$b8c2a040$%kim@samsung.com>
Date: Tue, 9 Apr 2013 10:54:17 +0530
X-Google-Sender-Auth: yWux2DbRPilqsX0aCZNq7Zpr5nw
Message-ID: <CADGdYn7_DP-8q8ERAFLQ74YUm0V+DST5+1ntH900Tka5K0n6fQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] thermal: exynos: Add thermal driver for exynos5440
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

On Tue, Apr 2, 2013 at 3:56 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Amit Daniel Kachhap wrote:
>>
>> This patchset adds TMU(Thermal management Unit) driver support for
>> exynos5440 platform. There are 3 instances of the TMU controllers so
>> necessary cleanup is done to handle multiple thermal zone.
>>
>> Patch 1 [thermal: exynos: Adapt to temperature emulation core thermal]
>> is a re-post of the earlier posted patch,
>> https://patchwork.kernel.org/patch/2123131/.
>>
>
> Looks OK to me on whole series, there is my ack only on 1st patch though.
>
> So if you want to add my ack, feel free:
>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>
> Thanks.
>
> - Kukjin

Any comment on this patchset? I know this patch series involves quite
lot of changes but these are important for this merge window. Also
they are now acked by Samsung platform maintainer.

Regards,
Amit Daniel
>
>> All these patches are based on thermal maintainers git tree,
>> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
>>
>> Amit Daniel Kachhap (9):
>>   thermal: exynos: Adapt to temperature emulation core thermal
>>     framework
>>   thermal: exynos: Add support for instance based register/unregister
>>   thermal: exynos: Moving into samsung directory for easy maintenance.
>>   thermal: exynos: Bifurcate exynos thermal common and tmu controller
>>     code
>>   thermal: exynos: Make the zone handling dependent on trip count
>>   thermal: exynos: small cleanups to prepare for adding exynos5440
>>     driver
>>   thermal: exynos: Add support for exynos5440 TMU sensor.
>>   thermal: exynos: Parse the platform data from the device tree.
>>   ARM: dts: Add device tree node for exynos5440 TMU controller
>>
>>  .../bindings/thermal/exynos5440-thermal.txt        |   93 ++
>>  Documentation/thermal/exynos_thermal_emulation     |    8 +-
>>  arch/arm/boot/dts/exynos5440.dtsi                  |   43 +
>>  drivers/thermal/Kconfig                            |   22 +-
>>  drivers/thermal/Makefile                           |    2 +-
>>  drivers/thermal/exynos_thermal.c                   | 1112
> --------------------
>>  drivers/thermal/samsung/Kconfig                    |   32 +
>>  drivers/thermal/samsung/Makefile                   |    6 +
>>  drivers/thermal/samsung/exynos4210_thermal.c       |  658 ++++++++++++
>>  drivers/thermal/samsung/exynos5440_thermal.c       |  712 +++++++++++++
>>  drivers/thermal/samsung/exynos_common.c            |  515 +++++++++
>>  drivers/thermal/samsung/exynos_common.h            |   74 ++
>>  include/linux/platform_data/exynos_thermal.h       |   37 +-
>>  13 files changed, 2163 insertions(+), 1151 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos5440-
>> thermal.txt
>>  delete mode 100644 drivers/thermal/exynos_thermal.c
>>  create mode 100644 drivers/thermal/samsung/Kconfig
>>  create mode 100644 drivers/thermal/samsung/Makefile
>>  create mode 100644 drivers/thermal/samsung/exynos4210_thermal.c
>>  create mode 100644 drivers/thermal/samsung/exynos5440_thermal.c
>>  create mode 100644 drivers/thermal/samsung/exynos_common.c
>>  create mode 100644 drivers/thermal/samsung/exynos_common.h
>
