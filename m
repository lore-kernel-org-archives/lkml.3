Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbbAZQvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:51:21 -0500
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:17258
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752808AbbAZQvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:51:19 -0500
Date: Mon, 26 Jan 2015 08:51:08 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        Ola Jeppson <ola@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: zynq: Fix usb0 pins
References: <1422290895-4046-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1422290895-4046-1-git-send-email-afaerber@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21284.006
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1b0d387535914b48b3a720ecbe143e08@BN1AFFO11FD032.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377424004)(50986999)(74316001)(19580405001)(86362001)(53416004)(76176999)(47776003)(83506001)(110136001)(87936001)(85182001)(106466001)(92566002)(54356999)(50466002)(92726002)(77156002)(33646002)(46102003)(6806004)(19580395003)(2950100001)(85202003)(104016003)(108616004)(23676002)(62966003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB012;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB012;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB012;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB012;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 16:51:16.9166
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1AFFO11HUB012
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-26 at 05:48PM +0100, Andreas Färber wrote:
> Fix usb0 pin 19 -> 29 (matching ethernet1 pins and manual).
> Pin 19 is used for ethernet0 on the Parallella board.
> 
> Fixes: add958cee967 ("pinctrl: Add driver for Zynq")
> Signed-off-by: Andreas Färber <afaerber@suse.de>
Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Soren
