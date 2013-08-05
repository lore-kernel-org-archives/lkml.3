Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab3HEHw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:52:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58208 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab3HEHwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:52:25 -0400
Message-ID: <51FF59B4.8060108@ti.com>
Date: Mon, 5 Aug 2013 10:52:20 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <tony@atomide.com>, <rnayak@ti.com>, <benoit.cousson@linaro.org>,
        <balbi@ti.com>, <kishon@ti.com>, <dmurphy@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ARM: dts: dra7: Add USB related nodes
References: <1375369134-26398-1-git-send-email-rogerq@ti.com> <1375369134-26398-3-git-send-email-rogerq@ti.com> <51FBCA10.9070806@ti.com>
In-Reply-To: <51FBCA10.9070806@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 06:02 PM, George Cherian wrote:
> On 8/1/2013 8:28 PM, Roger Quadros wrote:
>> Add nodes for the Super Speed USB controllers, omap-control-usb,
>> USB2 PHY and USB3 PHY devices.
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>   arch/arm/boot/dts/dra7.dtsi |  136 +++++++++++++++++++++++++++++++++++++++++++
>>   1 files changed, 136 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
>> index ce9a0f0..3a2e55e 100644
> 
> <snip>
> 
>> +        omap_dwc3_1@48880000 {
> 
> How about usb1: omap_dwc3@48880000 {
>           usb2: omap_dwc3@488c0000 { etc.
> 

Yes. will update it in next revision.

cheers,
-roger
