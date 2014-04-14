Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaDNHWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:22:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50606 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbaDNHWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:22:47 -0400
Message-ID: <534B8CC3.7050008@ti.com>
Date: Mon, 14 Apr 2014 10:22:43 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <tony@atomide.com>
CC: <balbi@ti.com>, <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: omap5: Add clocks to USB3 PHY node
References: <1396348647-11545-1-git-send-email-rogerq@ti.com> <1396348647-11545-2-git-send-email-rogerq@ti.com> <20140401141308.GB4717@saruman.home>
In-Reply-To: <20140401141308.GB4717@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 04/01/2014 05:13 PM, Felipe Balbi wrote:
> On Tue, Apr 01, 2014 at 01:37:27PM +0300, Roger Quadros wrote:
>> The USB3 PHY driver (ti-pipe3) was updated so that the relevant
>> clock phandles are expected in the DT node.
>> Provide the necessary clocks.
>>
>> Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Great!!!
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Could you please pick this up for 3.15-rc? Thanks.

cheers,
-roger

> 
>> ---
>>  arch/arm/boot/dts/omap5.dtsi | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
>> index 757f0b9..4df1e7a 100644
>> --- a/arch/arm/boot/dts/omap5.dtsi
>> +++ b/arch/arm/boot/dts/omap5.dtsi
>> @@ -794,6 +794,12 @@
>>  				      <0x4a084c00 0x40>;
>>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>>  				ctrl-module = <&omap_control_usb3phy>;
>> +				clocks = <&usb_phy_cm_clk32k>,
>> +					 <&sys_clkin>,
>> +					 <&usb_otg_ss_refclk960m>;
>> +				clock-names =	"wkupclk",
>> +						"sysclk",
>> +						"refclk";
>>  				#phy-cells = <0>;
>>  			};
>>  		};
>> -- 
>> 1.8.3.2
>>
> 

