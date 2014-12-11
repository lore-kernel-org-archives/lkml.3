Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155AbaLKI4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 03:56:44 -0500
Received: from mail-bn1bon0065.outbound.protection.outlook.com ([157.56.111.65]:13604
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932634AbaLKI4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 03:56:42 -0500
Date: Thu, 11 Dec 2014 09:56:18 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        atull <atull@opensource.altera.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 2/6] arm: dts: socfpga: add altera fpga manager
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-3-git-send-email-atull@opensource.altera.com>
 <20141210150109.GA23358@pengutronix.de>
 <alpine.DEB.2.02.1412101123530.25868@linuxheads99>
 <20141210174945.GC23358@pengutronix.de>
In-Reply-To: <20141210174945.GC23358@pengutronix.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21168.002
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <d9903a1dee0343c083dc7ec04a70ff99@BN1BFFO11FD015.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(479174003)(377454003)(24454002)(164054003)(51704005)(199003)(120916001)(106466001)(46102003)(21056001)(93886004)(86362001)(99396003)(77096005)(92726002)(23746002)(31966008)(33646002)(107046002)(6806004)(50466002)(74316001)(20776003)(19580405001)(19580395003)(64706001)(65806001)(47776003)(65956001)(83506001)(108616004)(64126003)(104016003)(4396001)(76176999)(92566001)(54356999)(50986999)(77156002)(62966003)(87936001)(65826006)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB024;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB024;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB024;
X-Forefront-PRVS: 0422860ED4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB024;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 06:49 PM, Steffen Trumtrar wrote:
> On Wed, Dec 10, 2014 at 11:25:59AM -0600, atull wrote:
>> On Wed, 10 Dec 2014, Steffen Trumtrar wrote:
>>
>>> Hi!
>>>
>>> On Tue, Dec 09, 2014 at 02:14:46PM -0600, atull@opensource.altera.com wrote:
>>>> From: Alan Tull <atull@opensource.altera.com>
>>>>
>>>> Add Altera FGPA manager to device tree.
>>>>
>>>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
>>>> ---
>>>>  arch/arm/boot/dts/socfpga.dtsi |   10 ++++++++++
>>>>  1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
>>>> index 4472fd9..bab98b6 100644
>>>> --- a/arch/arm/boot/dts/socfpga.dtsi
>>>> +++ b/arch/arm/boot/dts/socfpga.dtsi
>>>> @@ -751,5 +751,15 @@
>>>>  			compatible = "altr,sys-mgr", "syscon";
>>>>  			reg = <0xffd08000 0x4000>;
>>>>  		};
>>>> +
>>>> +		hps_0_fpgamgr: fpgamgr@0xff706000 {
>>>> +			compatible = "altr,fpga-mgr", "simple-bus";
>>>> +			reg = <0xFF706000 0x1000
>>>> +			       0xFFB90000 0x1000>;
>>>> +			interrupts = <0 175 4>;
>>>> +			#address-cells = <1>;
>>>> +			#size-cells = <1>;
>>>> +			ranges;
>>>> +		};
>>>
>>> The fpgamgr is NOT a bus. You don't need ranges and/or simple-bus.
>>>
>>> Regards,
>>> Steffen
>>
>> Actually, I am going to be using this when I add the DT notification 
>> stuff.  That stuff is waiting for DT overlays to show up in the main
>> tree.
>>
>> So the choice it to either change this file now, once, or do the minimal 
>> changes and have to change it again later.
>>
> 
> Yes, that is what I thought. And still, devices can NOT show up
> at the fpgamgr. They show up on the various bridges.
> 
> And as far as I understand the DT overlay stuff, you specify in
> the overlay what the parent node will be.
> For i2c this is one of the i2c-hosts, for spi one of the spi-hosts
> and for IP cores in a bitstream one of the bridges.
> 
> The fpgamgr is, from my understanding, only responsible for writing
> the bitstream to the FPGA; nothing more.

+1 on this.
I think you can easily decide later where DT overlays will be added.

Thanks,
Michal

