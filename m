Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaIXRGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:06:47 -0400
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:11104
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752213AbaIXRGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:06:46 -0400
Date: Wed, 24 Sep 2014 19:06:30 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: <linux-arm-kernel@lists.infradead.org>, <monstr@monstr.eu>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Rob Herring <robherring2@gmail.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: zynq: DT: Add missing reference for ADC
References: <fced9e56dc4ef8df9ead34f6444c010cc31c7a61.1411567289.git.michal.simek@xilinx.com>
 <20140924161814.GG13679@xsjandreislx>
In-Reply-To: <20140924161814.GG13679@xsjandreislx>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20950.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <f6b47676-f664-4b01-8c70-a526eb8d1931@BY2FFO11FD011.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(479174003)(377454003)(164054003)(24454002)(51704005)(189002)(377424004)(1496007)(23676002)(86362001)(44976005)(83322001)(19580405001)(31966008)(64126003)(64706001)(95666004)(19580395003)(85852003)(83072002)(92566001)(31696002)(92726001)(20776003)(83506001)(47776003)(87936001)(65806001)(65956001)(50986999)(76176999)(70736001)(46102003)(74662003)(102836001)(54356999)(81542003)(76482002)(81342003)(50466002)(90102001)(77982003)(80022003)(104016003)(21056001)(106466001)(79102003)(85306004)(6806004)(4396001)(10300001)(107046002)(74502003)(120916001)(99396003)(74316001)(65826006)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB011;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 06:18 PM, Sören Brinkmann wrote:
> On Wed, 2014-09-24 at 04:01PM +0200, Michal Simek wrote:
>> Add missing reference for ADC node.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>>  arch/arm/boot/dts/zynq-7000.dtsi | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
>> index 772381fe07bb..fc90f47f9c03 100644
>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
>> @@ -64,7 +64,7 @@
>>  		interrupt-parent = <&intc>;
>>  		ranges;
>>
>> -		adc@f8007100 {
>> +		adc: adc@f8007100 {
> I think we enumerated all labels. I.e. 'adc0' is probably better.

I was thinking about it and the reason I didn't use that adc0 was
that it is unique and it is just one in PS. Maybe there could be another adc in PL
but it will be probably automated not to use adc key world.
For PL part names was depending on user description.

Anyway logic was not to use enumerated label for unique IPs.

Thanks,
Michal

