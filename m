Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab3CFI4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 03:56:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52635 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab3CFI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 03:56:17 -0500
Message-ID: <51370494.7090902@ti.com>
Date: Wed, 6 Mar 2013 14:25:48 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 8/8] ARM: dts: omap5: add dwc3 core dt data
References: <1362494223-14151-1-git-send-email-kishon@ti.com> <1362494223-14151-9-git-send-email-kishon@ti.com> <20130305143934.GB12123@arwen.pp.htv.fi>
In-Reply-To: <20130305143934.GB12123@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 March 2013 08:09 PM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Mar 05, 2013 at 08:07:03PM +0530, Kishon Vijay Abraham I wrote:
>> Add dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
>> data file. The information for the entered data node is available @
>> Documentation/devicetree/bindings/usb/dwc3.txt
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   arch/arm/boot/dts/omap5.dtsi |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
>> index c4eb2ec..24dd69f 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -514,6 +514,13 @@
>>   			#size-cells = <1>;
>>   			utmi-mode = <2>;
>>   			ranges;
>> +			dwc3@4a030000 {
>> +				compatible = "synopsys,dwc3";
>> +				reg = <0x4a030000 0x1000>;
>> +				interrupts = <0 92 4>;
>> +				usb-phy = <&usb2_phy>, <&usb3_phy>;
>> +				tx-fifo-resize;
>
> I think this should be merged with previous patch. Also, we need to
> check whether tx-fifo-resize is needed with ES2 or not ;-)

yeah. ES2 works without tx-fifo-resize.

Thanks
Kishon
