Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514Ab3IPDEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 23:04:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49468 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980Ab3IPDEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 23:04:47 -0400
Message-ID: <52367520.8010909@ti.com>
Date: Mon, 16 Sep 2013 08:34:00 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] Documentation: dt bindings: move ..usb/usb-phy.txt
 to ..phy/omap-phy.txt
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-5-git-send-email-kishon@ti.com> <5231C040.4040609@ti.com>
In-Reply-To: <5231C040.4040609@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 September 2013 06:53 PM, Roger Quadros wrote:
> On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
>> Since now we have a separate folder for phy, move the PHY dt binding
>> documentation of OMAP to that folder.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   .../devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt}        |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>   rename Documentation/devicetree/bindings/{usb/usb-phy.txt => phy/omap-phy.txt} (96%)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/phy/omap-phy.txt
>> similarity index 96%
>> rename from Documentation/devicetree/bindings/usb/usb-phy.txt
>> rename to Documentation/devicetree/bindings/phy/omap-phy.txt
>> index 36bdb17..2c485ee 100644
>> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/omap-phy.txt
>
> ti-phy.txt?

maybe wait for that later?

Thanks
Kishon
