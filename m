Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbbALSUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:20:55 -0500
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:19975
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753663AbbALSUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:20:53 -0500
Date: Mon, 12 Jan 2015 10:20:49 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: pinconf-generic: loose DT dependence
References: <1421020166-22831-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421020166-22831-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21244.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <52c662b797754a37966532ef95304610@BL2FFO11FD050.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(199003)(189002)(377424004)(104016003)(83506001)(85202003)(85182001)(64706001)(110136001)(77156002)(62966003)(53416004)(74316001)(106466001)(108616004)(86362001)(87936001)(50986999)(54356999)(46102003)(47776003)(6806004)(50466002)(19580395003)(2950100001)(23676002)(76176999)(19580405001)(92566002)(92726002)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB066;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB066;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB066;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB066;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 18:20:51.6620
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB066
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 12:49AM +0100, Linus Walleij wrote:
> New pin controllers such as ACPI-based may also have custom properties
> to parse, and should be able to use generic pin config. Let's make the
> code compile on !OF systems and rename members a bit to underscore it
> is custom parameters and not necessarily DT parameters.
> 
> This fixes a build regression for x86_64 on the zeroday kernel builds.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-and-tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Sören
