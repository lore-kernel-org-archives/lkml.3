Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbbA2Ofh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:35:37 -0500
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:42635
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753065AbbA2Ofe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:35:34 -0500
Date: Thu, 29 Jan 2015 15:35:14 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] ARM: zynq: Remove bogus value from 'bias-disable'
 property
References: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
 <54C6DDE8.3000905@suse.de>
 <ce6e56872ab744a49612ef9bca07c73d@BN1AFFO11FD005.protection.gbl>
 <20150128154139.GK13057@xsjandreislx>
In-Reply-To: <20150128154139.GK13057@xsjandreislx>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21290.007
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <4cef3a322a8543cdb8f9f57eafd7a09b@BL2FFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; suse.de; dkim=none (message not
 signed) header.d=none;suse.de; dmarc=permerror action=none
 header.from=xilinx.com;
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(51704005)(377454003)(377424004)(164054003)(479174004)(24454002)(74316001)(92566002)(50466002)(2950100001)(19580395003)(87936001)(83506001)(62966003)(6806004)(92726002)(64126003)(77156002)(46102003)(65806001)(65956001)(108616004)(106466001)(93886004)(76176999)(54356999)(50986999)(23676002)(104016003)(77096005)(47776003)(19580405001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB018;H:xir-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2FFO11HUB018;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB018;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 14:35:32.5168
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[62.221.5.235]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 04:41 PM, Sören Brinkmann wrote:
> On Wed, 2015-01-28 at 03:21PM +0100, Michal Simek wrote:
>> On 01/27/2015 01:38 AM, Andreas Färber wrote:
>>> Am 26.01.2015 um 20:49 schrieb Soren Brinkmann:
>>>> In one pinctrl node, a 'bias-disable' property is erroneously assigned a
>>>> value.
>>>>
>>>> Fixes: ARM: zynq: DT: Add pinctrl information
>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>
>>> Reviewed-by: Andreas Färber <afaerber@suse.de>
>>>
>>> Andreas
>>>
>>
>> Applied both.
> 
> Thanks. Given how the branch looks now, you could squash 'ARM: zynq: DT:
> Remove bogus value from 'bias-disable' property' and 'ARM: zynq: DT: Add
> pinctrl information to USB nodes' into 'ARM: zynq: DT: Add pinctrl
> information'. Then we have it all in one patch and spare everybody the
> intermittent, partly broken commits.

That's not a problem. I have sent pull request with current state.

Thanks,
Michal

