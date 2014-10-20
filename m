Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaJTNaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:30:03 -0400
Received: from mail-bn1bon0054.outbound.protection.outlook.com ([157.56.111.54]:12544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751273AbaJTNaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:30:00 -0400
Date: Mon, 20 Oct 2014 15:14:34 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: zynq: Move common.h to generic location
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
 <20141013202453.GQ13679@xsjandreislx>
In-Reply-To: <20141013202453.GQ13679@xsjandreislx>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21038.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <0f2fd0e26a34479ea7e12d49789cc485@BN1BFFO11FD051.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(377454003)(51704005)(189002)(24454002)(377424004)(6806004)(44976005)(80022003)(46102003)(74316001)(31966008)(102836001)(47776003)(23676002)(85852003)(95666004)(20776003)(86362001)(92566001)(64706001)(107046002)(19580395003)(104016003)(19580405001)(85306004)(108616004)(33646002)(87936001)(4396001)(54356999)(21056001)(106466001)(76176999)(50986999)(76482002)(99396003)(50466002)(120916001)(41533002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB020;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03706074BC
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2014 10:24 PM, Sören Brinkmann wrote:
> On Mon, 2014-10-06 at 01:44PM +0200, Michal Simek wrote:
>> include/soc/zynq/ is the right location for this header
>> to be able to share information from this header with other
>> drivers which require it.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  arch/arm/mach-zynq/common.c                       | 2 +-
>>  arch/arm/mach-zynq/hotplug.c                      | 2 +-
>>  arch/arm/mach-zynq/platsmp.c                      | 2 +-
>>  arch/arm/mach-zynq/slcr.c                         | 2 +-
> 
> In the 3.18 merge window arch/arm/mach-zynq/pm.c had been added which is
> not covered in this version of the patch.

Thanks will send v2.
Michal

