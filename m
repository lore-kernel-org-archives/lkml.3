Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaLQSeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:34:18 -0500
Received: from mail-bn1bon0087.outbound.protection.outlook.com ([157.56.111.87]:59712
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751516AbaLQSeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:34:13 -0500
Date: Wed, 17 Dec 2014 19:33:54 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, <atull@opensource.altera.com>
CC: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Insop Song <insop.song@gainspeed.com>
Subject: Re: [PATCH v5 6/6] ARM: socfpga: defconfig: enable fpga manager
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
 <1418835289-15752-7-git-send-email-atull@opensource.altera.com>
 <20141217173216.GA24913@kroah.com>
In-Reply-To: <20141217173216.GA24913@kroah.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21182.001
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <88f9ec210ca64436bfadc050ec4e17bf@BN1BFFO11FD042.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(164054003)(24454002)(189002)(199003)(479174004)(51704005)(83506001)(4396001)(19580405001)(19580395003)(92566001)(31966008)(21056001)(87936001)(6806004)(65956001)(65806001)(108616004)(106466001)(2950100001)(92726002)(77096005)(99396003)(120916001)(107046002)(46102003)(86362001)(33646002)(104016003)(62966003)(20776003)(47776003)(77156002)(64706001)(54356999)(76176999)(50986999)(50466002)(23746002)(74316001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB038;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB038;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB038;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB038;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 06:32 PM, Greg KH wrote:
> On Wed, Dec 17, 2014 at 10:54:49AM -0600, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
>>
>> Enable FPGA manager for Altera socfpga.
>>
>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>> ---
>> v5: s/CONFIG_FPGA_MGR_ALTERA/CONFIG_FPGA_MGR_SOCFPGA/
>> ---
>>  arch/arm/configs/socfpga_defconfig |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
>> index a2956c3..f1d6a3b 100644
>> --- a/arch/arm/configs/socfpga_defconfig
>> +++ b/arch/arm/configs/socfpga_defconfig
>> @@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
>>  CONFIG_USB_DWC2_HOST=y
>>  CONFIG_MMC=y
>>  CONFIG_MMC_DW=y
>> +CONFIG_STAGING=y
>> +CONFIG_FPGA=y
>> +CONFIG_FPGA_MGR_SYSFS=y
>> +CONFIG_FPGA_MGR_SOCFPGA=y
>>  CONFIG_EXT2_FS=y
>>  CONFIG_EXT2_FS_XATTR=y
>>  CONFIG_EXT2_FS_POSIX_ACL=y
> 
> Do defconfigs really matter anymore?

If they want but anyway simply 5/6 and 6/6 shouldn't be the part of this series
because they should go through arm-soc tree.

I will look at other patches tmr.

Monam, Insop: I think you should join this process because gs_fpgaboot
should be one backend driver of this interface.

Thanks,
Michal
