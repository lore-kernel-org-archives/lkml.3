Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab3HNTRI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:17:08 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:21265
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758446Ab3HNTRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:17:06 -0400
Message-ID: <520BD79A.50307@caviumnetworks.com>
Date: Wed, 14 Aug 2013 12:16:42 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: <linux-gpio@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
CC: <ralf@linux-mips.org>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 0/2] OCTEON GPIO support.
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0938781D02
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(54094003)(51704005)(479174003)(377454003)(24454002)(189002)(199002)(81686001)(74366001)(49866001)(47736001)(74706001)(76796001)(76786001)(64126003)(83072001)(69226001)(4396001)(50986001)(81542001)(50466002)(47976001)(81342001)(53416003)(81816001)(79102001)(23756003)(80976001)(63696002)(47776003)(83322001)(19580405001)(56816003)(19580395003)(56776001)(46102001)(54316002)(51856001)(77096001)(54356001)(74876001)(53806001)(65956001)(74502001)(66066001)(31966008)(80022001)(33656001)(74662001)(65806001)(47446002)(76482001)(59766001)(77982001)(16406001)(36756003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB145;H:BLUPRD0712HT001.namprd07.prod.outlook.com;CLIP:64.2.3.195;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

Hi Linus,

I wonder if you have had a chance to look at these...

David Daney


On 07/29/2013 02:29 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
>
> The Cavium, OCTEON is a MIPS based SoC.  Here we add support for its
> on-chip GPIO lines.
>
> Changes from v1: Cleaned up variable names, messages and added some
> comments as suggested by Linus Walleij.
>
> The second patch depends on the first, but is in code maintained by
> Ralf.  It may be best to mrege both of these together, perhaps from
> the GPIO tree, with Ralf's Acked-by.
>
> David Daney (2):
>    MIPS: OCTEON: Select ARCH_REQUIRE_GPIOLIB
>    gpio MIPS/OCTEON: Add a driver for OCTEON's on-chip GPIO pins.
>
>   arch/mips/Kconfig                               |   1 +
>   arch/mips/include/asm/mach-cavium-octeon/gpio.h |  21 ++++
>   drivers/gpio/Kconfig                            |   8 ++
>   drivers/gpio/Makefile                           |   1 +
>   drivers/gpio/gpio-octeon.c                      | 157 ++++++++++++++++++++++++
>   5 files changed, 188 insertions(+)
>   create mode 100644 arch/mips/include/asm/mach-cavium-octeon/gpio.h
>   create mode 100644 drivers/gpio/gpio-octeon.c
>

