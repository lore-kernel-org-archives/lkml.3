Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab3G2VtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:49:23 -0400
Received: from mail-bn1lp0154.outbound.protection.outlook.com ([207.46.163.154]:40176
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754397Ab3G2VtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:49:22 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2013 17:49:22 EDT
Message-ID: <51F6DF65.9050301@caviumnetworks.com>
Date: Mon, 29 Jul 2013 14:32:21 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: <ralf@linux-mips.org>, Linus Walleij <linus.walleij@linaro.org>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 0/2] OCTEON GPIO support.
References: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1375133350-18828-1-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 09222B39F5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(377454003)(479174003)(51704005)(24454002)(199002)(189002)(74366001)(79102001)(16406001)(74662001)(23756003)(51856001)(74876001)(65806001)(76796001)(76786001)(65956001)(69226001)(80976001)(80022001)(63696002)(66066001)(64126003)(81542001)(47776003)(81342001)(83072001)(53416003)(31966008)(74706001)(74502001)(47446002)(56776001)(76482001)(33656001)(49866001)(80316001)(50986001)(4396001)(59766001)(47736001)(47976001)(77982001)(50466002)(19580405001)(54356001)(36756003)(53806001)(83322001)(56816003)(19580395003)(46102001)(59896001)(54316002)(77096001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR07MB032;H:BN1PRD0712HT002.namprd07.prod.outlook.com;CLIP:64.2.3.195;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Really I meant to say that the first patch is in the MIPS tree, and 
should be Acked-by Ralf, if that wasn't clear.

David Daney


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

