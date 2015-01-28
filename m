Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbbA1UOz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:14:55 -0500
Received: from mail-bn1on0065.outbound.protection.outlook.com ([157.56.110.65]:9434
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754444AbbA1UOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:52 -0500
Date: Wed, 28 Jan 2015 07:41:39 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] ARM: zynq: Remove bogus value from 'bias-disable'
 property
References: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
 <54C6DDE8.3000905@suse.de>
 <ce6e56872ab744a49612ef9bca07c73d@BN1AFFO11FD005.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce6e56872ab744a49612ef9bca07c73d@BN1AFFO11FD005.protection.gbl>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <421020c5dac8492ea949dc202441c184@BL2FFO11FD054.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; linaro.org; dkim=none (message not
 signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(479174004)(377454003)(377424004)(51704005)(6806004)(110136001)(108616004)(62966003)(77156002)(23676002)(76176999)(2950100001)(87936001)(54356999)(104016003)(74316001)(50466002)(19580395003)(47776003)(83506001)(50986999)(86362001)(85202003)(92726002)(106466001)(53416004)(92566002)(85182001)(19580405001)(46102003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB067;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB067;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB067;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB067;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 15:41:49.7106
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB067
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 03:21PM +0100, Michal Simek wrote:
> On 01/27/2015 01:38 AM, Andreas Färber wrote:
> > Am 26.01.2015 um 20:49 schrieb Soren Brinkmann:
> >> In one pinctrl node, a 'bias-disable' property is erroneously assigned a
> >> value.
> >>
> >> Fixes: ARM: zynq: DT: Add pinctrl information
> >> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > 
> > Reviewed-by: Andreas Färber <afaerber@suse.de>
> > 
> > Andreas
> > 
> 
> Applied both.

Thanks. Given how the branch looks now, you could squash 'ARM: zynq: DT:
Remove bogus value from 'bias-disable' property' and 'ARM: zynq: DT: Add
pinctrl information to USB nodes' into 'ARM: zynq: DT: Add pinctrl
information'. Then we have it all in one patch and spare everybody the
intermittent, partly broken commits.

	Sören
