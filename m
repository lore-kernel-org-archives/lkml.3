Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaIPGOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:14:32 -0400
Received: from mail-by2on0112.outbound.protection.outlook.com ([207.46.100.112]:14709
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753133AbaIPGO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:14:29 -0400
X-WSS-ID: 0NBZDBZ-07-R82-02
X-M-MSG: 
Message-ID: <5417BC57.4030504@amd.com>
Date: Mon, 15 Sep 2014 23:28:07 -0500
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-acpi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>
Subject: Re: [RFC PATCH for AMD Seattle 0/4] Drivers for AMD-Seatlle to boot
 from ACPI
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(243025005)(479174003)(377454003)(199003)(51704005)(24454002)(85306004)(44976005)(19580395003)(47776003)(85852003)(80316001)(19580405001)(54356999)(15975445006)(15202345003)(50466002)(76482001)(65816999)(64706001)(20776003)(102836001)(33656002)(65806001)(84676001)(99396002)(76176999)(50986999)(86362001)(97736003)(21056001)(2201001)(107046002)(92726001)(64126003)(4396001)(31966008)(68736004)(59896002)(83072002)(92566001)(87936001)(101416001)(83322001)(95666004)(65956001)(87266999)(23746002)(105586002)(36756003)(106466001)(90102001)(83506001)(77982003)(74662003)(46102003)(74502003)(80022003)(79102003)(81342003)(81542003)(2101003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR02MB496;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: Correcting the typo for linux-acpi mailing list in this reply.

Also, I would like to add the link to the "AMD Opteron™ A1100 Series 
Processor ACPI Porting Guide", which describes the current ACPI table 
for AMD Seattle platform here:

http://amd-dev.wpengine.netdna-cdn.com/wordpress/media/2012/10/Seattle_ACPI_Guide.pdf

Suravee

On 09/15/2014 07:47 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> As a follow up of the email thread:
>
>      [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
>      https://lkml.org/lkml/2014/9/1/446
>
> Besides Hanjun Guo's patches above, these are the additional patches required
> to boot AMD Seattle platform with full ACPI support:
>
>      [PATCH] efi/arm64: efistub: don't abort if base of DRAM is occupied
>      http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/272274.html
>
>      [PATCH v2] efi/arm64: fix fdt-related memory reservation
>      https://lkml.org/lkml/2014/9/8/483
>
>      [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
>      https://lkml.org/lkml/2014/9/9/834
>
>      [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
>      https://lkml.org/lkml/2014/9/1/448
>      (NOTE: This is not meant to be submitted upstream, but required to enable
>       ACPI support for UART SBSA driver.)
>
> These patches are rebased from the linux-3.17-rc4 upstream kernel, and
> compatible with the AMD Seattle Firmware version ROD0070C.
> The full kernel boot log can be found here:
>
>      http://people.linaro.org/~al.stone/seattle-boot-acpi-dmesg.txt
>
> Suravee / Al
>
> Ard Biesheuvel (1):
>    arm64/efi: efistub: don't abort if base of DRAM is occupied
>
> Grame Gregory (1):
>    [RFC PATCH for Juno 2/2] tty: SBSA compatible UART
>
> Mark Salter (1):
>    efi/arm64: fix fdt-related memory reservation
>
> Suravee Suthikulpanit (1):
>    ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
>
>   arch/arm64/kernel/efi-stub.c       |  16 +-
>   arch/arm64/mm/init.c               |   3 +-
>   drivers/ata/Kconfig                |   2 +-
>   drivers/ata/ahci_platform.c        |  13 ++
>   drivers/firmware/efi/libstub/fdt.c |  10 +-
>   drivers/tty/Kconfig                |   6 +
>   drivers/tty/Makefile               |   1 +
>   drivers/tty/sbsauart.c             | 328 +++++++++++++++++++++++++++++++++++++
>   8 files changed, 365 insertions(+), 14 deletions(-)
>   create mode 100644 drivers/tty/sbsauart.c
>
