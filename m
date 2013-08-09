Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968290Ab3HISmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:42:14 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48956 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967943Ab3HISmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:42:12 -0400
Subject: Re: [PATCH] usb: dwc3: core: clarify usb-phy array binding
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130809162848.GW27325@e106331-lin.cambridge.arm.com>
Date: Fri, 9 Aug 2013 13:42:15 -0500
Cc: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <1A03353A-9299-4D73-9786-4ECBC1DD4E05@codeaurora.org>
References: <1376062832-23288-1-git-send-email-galak@codeaurora.org> <20130809162848.GW27325@e106331-lin.cambridge.arm.com>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 9, 2013, at 11:28 AM, Mark Rutland wrote:

> On Fri, Aug 09, 2013 at 04:40:32PM +0100, Kumar Gala wrote:
>> The binding spec wasn't clear that the order of the phandles in the
>> usb-phy array has meaning.  Clarify this point in the binding that
>> it should be <USB2-HS-PHY, USB3-SS-PHY>.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> Documentation/devicetree/bindings/usb/dwc3.txt | 4 +++-
>> 1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/usb/dwc3.txt b/Documentation/devicetree/bindings/usb/dwc3.txt
>> index 7a95c65..8a9770b 100644
>> --- a/Documentation/devicetree/bindings/usb/dwc3.txt
>> +++ b/Documentation/devicetree/bindings/usb/dwc3.txt
>> @@ -6,7 +6,9 @@ Required properties:
>>  - compatible: must be "synopsys,dwc3"
>>  - reg : Address and length of the register set for the device
>>  - interrupts: Interrupts used by the dwc3 controller.
>> - - usb-phy : array of phandle for the PHY device
>> + - usb-phy : array of phandle for the PHY device.  The first element
>> +   in the array is expected to be a handle to the USB2/HS PHY and
>> +   the second element is expected to be a handle to the USB3/SS PHY
> 
> Just to check - it's not valid to have a USB3 phy without a USB2 phy?

Don't know, hopefully Felipe will chime in on that.

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

