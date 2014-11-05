Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaKEHUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:20:07 -0500
Received: from mail-bn1bon0070.outbound.protection.outlook.com ([157.56.111.70]:43003
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753644AbaKEHUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:20:02 -0500
Date: Wed, 5 Nov 2014 08:19:41 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <davem@davemloft.net>,
        <sthokal@xilinx.com>, <manuel.schoelling@gmx.de>,
        <f.fainelli@gmail.com>, <paul.gortmaker@windriver.com>,
        <ebiederm@xmission.com>
CC: <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: net: ethernet: xilinx: xilinx_emaclite: revert
 the original commit "1db3ddff1602edf2390b7667dcbaa0f71512e3ea"
References: <5458E605.6070801@gmail.com>
In-Reply-To: <5458E605.6070801@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <a39951cc744047679d13b23e76c97347@BN1BFFO11FD022.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(31014004)(377454003)(24454002)(189002)(164054003)(51704005)(31966008)(108616004)(74316001)(47776003)(20776003)(65956001)(64706001)(23676002)(76176999)(86362001)(64126003)(50986999)(6806004)(87936001)(19580405001)(92566001)(44976005)(19580395003)(104016003)(54356999)(2201001)(83506001)(95666004)(50466002)(4396001)(99396003)(46102003)(120916001)(62966003)(33646002)(21056001)(77156002)(107046002)(106466001)(102836001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB025;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB025;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 03:43 PM, Chen Gang wrote:
> Microblaze is a fpga soft core, it can be customized easily, which may
> cause many various hardware version strings.
> 
> So the original fix patch based on hard-coded compatible version strings
> is not a good idea (although it is correct for current issue). For it,
> there will be a new solving way soon (which based on the device tree).
> 
> The original issue is related with qemu, so can only change the hardware
> version string in qemu for it, then keep the original driver no touch (
> qemu is for virtualization which has much easier life than real world).
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 1 -
>  1 file changed, 1 deletion(-)

Acked-by: Michal Simek <michal.simek@xilinx.com>

Thanks,
Michal

