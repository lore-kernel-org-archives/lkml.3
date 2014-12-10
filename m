Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbaLJOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:38:38 -0500
Received: from mail-bn1bon0092.outbound.protection.outlook.com ([157.56.111.92]:13976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756452AbaLJOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:38:37 -0500
Date: Wed, 10 Dec 2014 15:38:18 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?windows-1252?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] gpio/xilinx: Add support for X86 Arch
References: <1418217710-11987-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418217710-11987-4-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1418217710-11987-4-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21164.004
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <8dff12b43e18420b8f4413daf5964afc@BN1BFFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377454003)(164054003)(479174003)(189002)(24454002)(199003)(87936001)(83506001)(107886001)(77096005)(120916001)(64706001)(99396003)(20776003)(77156002)(62966003)(31966008)(107046002)(47776003)(21056001)(92566001)(19580405001)(2201001)(65956001)(106466001)(6806004)(65806001)(4396001)(108616004)(104016003)(33646002)(23746002)(46102003)(54356999)(50986999)(76176999)(92726002)(19580395003)(50466002)(74316001)(86362001)(558084003)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB058;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-Forefront-PRVS: 0421BF7135
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 02:21 PM, Ricardo Ribalda Delgado wrote:
> Core can be accessed via PCIe on X86 platform.
> 

You should also describe also that you are changing that this driver
can be used as module.

> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---

Thanks,
Michal

