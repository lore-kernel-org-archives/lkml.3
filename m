Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaKKLtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:49:03 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:57825 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaKKLs7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:48:59 -0500
MIME-Version: 1.0
In-Reply-To: <201411111230.30686.linux@rainbow-software.org>
References: <1415638712-18486-1-git-send-email-linux@rainbow-software.org>
	<CAPDyKFpUS6yG1Fq+dVFn_8AG7-_B-_moo2JCz4AQBKgvp-YaHQ@mail.gmail.com>
	<201411111230.30686.linux@rainbow-software.org>
Date: Tue, 11 Nov 2014 12:48:58 +0100
Message-ID: <CAPDyKFoe9FCaKPvr7FpmGY5xzUDPVMgcKY3gmaBQ7keov6L39Q@mail.gmail.com>
Subject: Re: [PATCH v4] mmc: add Toshiba PCI SD controller driver
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2014 12:30, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Tuesday 11 November 2014, Ulf Hansson wrote:
>> On 10 November 2014 17:58, Ondrej Zary <linux@rainbow-software.org> wrote:
>> > This patch resurrects an old never-finished driver for Toshiba PCI SD
>> > controllers found in some older Toshiba laptops (such as Portege R100):
>> >
>> > 02:0d.0 System peripheral [0880]: Toshiba America Info Systems SD TypA
>> > Controller [1179:0805] (rev 05)
>> >
>> > The code is fixed, cleaned up and successfully tested with SD, SDHC, SDXC
>> > and MMC cards on Portege R100. (MMC cards don't even work in Windows!)
>> > SDIO probably does not work (don't have any SDIO card).
>> >
>> > The hardware is slow (around 2 MB/s - same in Windows) because it does
>> > not support bus mastering (busmaster enable bit cannot be set in PCI
>> > control reg). Also the card clock is limited to 16MHz (33MHz PCI clock
>> > divided by 2).
>> >
>> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
>>
>> Hi Ondrej,
>>
>> I get these compiler warning while building for x86. Can you please fix
>> them.
>>
>> ../drivers/mmc/host/toshsd.c: In function ‘toshsd_init’:
>> ../drivers/mmc/host/toshsd.c:70:9: warning: large integer implicitly
>> truncated to unsigned type [-Woverflow]
>>          host->ioaddr + SD_INTMASKCARD);
>>          ^
>
> Which GCC version did you use? I get no warnings with 4.7.2 (Debian Stable).

gcc (Ubuntu 4.8.2-19ubuntu1) 4.8.2

Kind regards
Uffe
