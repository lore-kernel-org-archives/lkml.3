Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaKGG7s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 01:59:48 -0500
Received: from mail-bn1bon0081.outbound.protection.outlook.com ([157.56.111.81]:17584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750974AbaKGG7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 01:59:46 -0500
Date: Fri, 7 Nov 2014 07:44:16 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        "Sean Rickerd" <srickerd@suse.com>, <stable@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: zynq: Enable PL clocks for Parallella
References: <1415294531-8942-1-git-send-email-afaerber@suse.de>
In-Reply-To: <1415294531-8942-1-git-send-email-afaerber@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21082.000
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <eca8ae5de8184151b03d3fd8d23c62a7@BY2FFO11FD010.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(199003)(24454002)(377454003)(479174003)(189002)(51704005)(31966008)(44976005)(6806004)(19580395003)(64126003)(106466001)(107046002)(102836001)(95666004)(19580405001)(47776003)(20776003)(64706001)(4396001)(83506001)(21056001)(86362001)(87936001)(23676002)(50986999)(76176999)(54356999)(108616004)(50466002)(74316001)(92566001)(99396003)(46102003)(77156002)(62966003)(120916001)(104016003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB002;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB002;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 06:22 PM, Andreas Färber wrote:
> The Parallella board comes with a U-Boot bootloader that loads one of
> two predefined FPGA bitstreams before booting the kernel. Both define an
> AXI interface to the on-board Epiphany processor.
> 
> Enable clocks FCLK0..FCLK3 for the Programmable Logic by default.
> 
> Otherwise accessing, e.g., the ESYSRESET register freezes the board,
> as seen with the Epiphany SDK tools e-reset and e-hw-rev, using /dev/mem.
> 
> Cc: <stable@vger.kernel.org> # 3.17.x
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  Michal/Olof, please consider this trivial patch as a fix for 3.18.

Acked-by: Michal Simek <michal.simek@xilinx.com>

Olof, Arnd: Can you please pick this directly?

Thanks,
Michal

