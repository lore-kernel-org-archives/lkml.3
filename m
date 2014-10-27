Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaJ0TPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:15:08 -0400
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:33721
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752571AbaJ0TPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:15:03 -0400
X-WSS-ID: 0NE4ASU-08-230-02
X-M-MSG: 
Message-ID: <544E99A4.4020906@amd.com>
Date: Mon, 27 Oct 2014 14:14:44 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: <mark.rutland@arm.com>, <will.deacon@arm.com>, <catalin.marinas@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, <marc.zyngier@arm.com>,
        <liviu.dudau@arm.com>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH V2] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <1414436065-7717-1-git-send-email-suravee.suthikulpanit@amd.com>
 <2202046.Qx9l5PJfzL@wuerfel>
In-Reply-To: <2202046.Qx9l5PJfzL@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(479174003)(377454003)(51704005)(24454002)(85852003)(4396001)(87266999)(76176999)(50986999)(92566001)(92726001)(54356999)(87936001)(97736003)(47776003)(20776003)(64706001)(65806001)(65956001)(36756003)(86362001)(68736004)(19580395003)(19580405001)(80316001)(44976005)(106466001)(120886001)(120916001)(50466002)(84676001)(83506001)(76482002)(107046002)(23746002)(21056001)(85306004)(80022003)(46102003)(31966008)(59896002)(105586002)(99396003)(95666004)(102836001)(33656002)(101416001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 2:07 PM, Arnd Bergmann wrote:
> On Monday 27 October 2014 13:54:25 suravee.suthikulpanit@amd.com wrote:
>> +       sata0: sata@00300000 {
>> +               compatible = "snps,spear-ahci";
>> +               reg = <0 0x300000 0 0x800>;
>> +               interrupts = <0 355 4>;
>> +               clocks = <&sataclk_333mhz>;
>> +               clock-names = "apb_pclk";
>> +               dma-coherent;
>> +       };
>
> Please use "snps,dwc-ahci" as the compatible string for a designware
> ahci controller, not "snps,spear-ahci", which refers to the implementation
> of that in the ST microelectronics SPEAr consumer SoC.
>
> It would be good to also add a string that is specific for your SoC if
> we ever need to identify it directly.
>
> 	Arnd
>

Thanks. I will update this in V3.

Suravee

