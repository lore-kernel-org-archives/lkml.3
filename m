Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaJTOKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:10:53 -0400
Received: from mail-bn1bon0094.outbound.protection.outlook.com ([157.56.111.94]:36576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752383AbaJTOKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:10:51 -0400
Date: Mon, 20 Oct 2014 16:10:32 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>, <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/3] ARM: zynq: Enable generic allocator
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
 <e5623273ff5d730b54c0c7dfe306dfbb98d4f058.1413811526.git.michal.simek@xilinx.com>
 <3551714.krTvviG9Ue@wuerfel>
In-Reply-To: <3551714.krTvviG9Ue@wuerfel>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21038.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <ab55e527012b44b4ba75d164116cf2bd@BN1BFFO11FD039.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377454003)(479174003)(164054003)(189002)(51704005)(24454002)(74316001)(107046002)(33646002)(85306004)(108616004)(64706001)(20776003)(31966008)(47776003)(23746002)(15975445006)(54356999)(85852003)(86362001)(19580405001)(50986999)(92566001)(76176999)(44976005)(19580395003)(87936001)(6806004)(15202345003)(50466002)(21056001)(4396001)(46102003)(76482002)(80022003)(120916001)(104016003)(99396003)(106466001)(95666004)(102836001)(41533002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB005;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB005;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2014 03:34 PM, Arnd Bergmann wrote:
> On Monday 20 October 2014 15:25:32 Michal Simek wrote:
>> Enable generic allocator by default because it is used by OCMC driver.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> 
> Why doesn't the driver select this then?

It can but currently OCM driver is enabled by default without Kconfig entry.

Appreciate your input on driver itself.
http://lists.openwall.net/linux-kernel/2014/10/06/196

Thanks,
Michal
