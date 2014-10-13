Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaJMU0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:26:00 -0400
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:17120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754249AbaJMUZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:25:56 -0400
Date: Mon, 13 Oct 2014 13:24:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: zynq: Move common.h to generic location
References: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <565908c2d70764e281d6a9b28d9599cea87823a3.1412595859.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21018.004
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <072b20fe15464ebfb94ecbeba79afdd8@BY2FFO11FD022.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(189002)(51704005)(199003)(377424004)(19580395003)(76176999)(76482002)(80022003)(6806004)(83506001)(85202003)(120916001)(85306004)(110136001)(74316001)(44976005)(46102003)(21056001)(92566001)(86362001)(20776003)(104016003)(19580405001)(47776003)(64706001)(50466002)(53416004)(77096002)(106466001)(102836001)(107046002)(85852003)(85182001)(50986999)(31966008)(108616004)(4396001)(54356999)(95666004)(23676002)(87936001)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB015;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB015;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03630A6A4A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 01:44PM +0200, Michal Simek wrote:
> include/soc/zynq/ is the right location for this header
> to be able to share information from this header with other
> drivers which require it.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
>  arch/arm/mach-zynq/common.c                       | 2 +-
>  arch/arm/mach-zynq/hotplug.c                      | 2 +-
>  arch/arm/mach-zynq/platsmp.c                      | 2 +-
>  arch/arm/mach-zynq/slcr.c                         | 2 +-

In the 3.18 merge window arch/arm/mach-zynq/pm.c had been added which is
not covered in this version of the patch.

	Sören
