Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaFXTtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:49:09 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:30886
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753257AbaFXTtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:49:06 -0400
X-WSS-ID: 0N7OFBD-08-0CF-02
X-M-MSG: 
Message-ID: <53A98687.7090408@amd.com>
Date: Tue, 24 Jun 2014 09:09:11 -0500
From: Joel Schopp <joel.schopp@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>, <marc.zyngier@arm.com>,
        <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Introduce ARM GICv2m MSI(-X) support
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(479174003)(377454003)(199002)(189002)(53416004)(59896001)(74502001)(77982001)(102836001)(95666004)(79102001)(64126003)(2201001)(23756003)(4396001)(76482001)(50466002)(77096002)(92566001)(86362001)(92726001)(21056001)(83506001)(33656002)(97736001)(76176999)(85306003)(54356999)(87266999)(65816999)(50986999)(68736004)(44976005)(15975445006)(80316001)(87936001)(80022001)(84676001)(19580395003)(65956001)(101416001)(36756003)(83072002)(105586002)(106466001)(46102001)(65806001)(81542001)(74662001)(19580405001)(99396002)(85852003)(31966008)(20776003)(64706001)(47776003)(83322001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:BN3PR0201MB0916;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Joel.Schopp@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been running and doing development on top of these patches.  I 
found a problem in an earlier version that i can confirm is now fixed in 
this current version.

Reviewed-by: Joel Schopp <joel.schopp@amd.com>

On 06/23/2014 07:32 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This patch set introduces support for MSI(-X) in GICv2m specification,
> which is implemented in some variation of GIC400.
>
> This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
> (https://lkml.org/lkml/2014/3/14/320).
>
> Suravee Suthikulpanit (2):
>    arm/gic: Add binding probe for GIC400
>    arm/gic: Add supports for GICv2m MSI(-X)
>
>   Documentation/devicetree/bindings/arm/gic.txt |  18 +-
>   drivers/irqchip/Kconfig                       |   6 +
>   drivers/irqchip/Makefile                      |   1 +
>   drivers/irqchip/gic-msi-v2m.c                 | 249 ++++++++++++++++++++++++++
>   drivers/irqchip/gic-msi-v2m.h                 |  20 +++
>   drivers/irqchip/irq-gic.c                     |  23 ++-
>   6 files changed, 313 insertions(+), 4 deletions(-)
>   create mode 100644 drivers/irqchip/gic-msi-v2m.c
>   create mode 100644 drivers/irqchip/gic-msi-v2m.h
>

