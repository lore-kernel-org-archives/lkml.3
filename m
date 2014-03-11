Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaCKNLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:11:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51181 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbaCKNLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:11:03 -0400
Message-ID: <531F0B49.2070008@ti.com>
Date: Tue, 11 Mar 2014 15:10:33 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <tony@atomide.com>
CC: <bcousson@baylibre.com>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
References: <1393510711-4697-1-git-send-email-rogerq@ti.com> <531ECDCB.4060700@ti.com> <20140311120259.GI21216@lee--X1> <531EFE97.1090202@ti.com> <20140311130715.GM21216@lee--X1>
In-Reply-To: <20140311130715.GM21216@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 03:07 PM, Lee Jones wrote:
> 
>>>>> This patchset brings up USB Host ports and Ethernet port on
>>>>> the OMAP5 uEVM board.
>>>>>
>>>>> It also does some cleanup with respect to DT clock binding
>>>>> for the mfd/omap-usb-host driver.
>>>>>
>>>>> Please queue these for -next.
>>>>>
>>>>> Lee,
>>>>>
>>>>> I've folded some platform data dependent patches with mfd patches
>>>>> so that they don't break functionality when applied individually.
>>>>> You can safely pull in all MFD patches (1 to 6).
>>>>>
>>>>> Tony & Benoit,
>>>>>
>>>>> Can you please accept patches 7, 8 and 9?
>>>>
>>>> Tony has already picked up 7,8 and 9 through omap-soc tree.
>>>>
>>>> Since you acked most patches except 5 and 6, are you fine if Tony takes
>>>> all the patches 1 to 4 in this series via omap-soc tree?
>>>>
>>>> What about patches 5 and 6?
>>>
>>> Any patches which are orthogonal can just be sucked into whichever tree
>>> they belong in. If there are inter-subsystem dependencies I'd prefer
>>> to take them and issue a immutable branch pull-request to the other
>>> maintainers.
>>>
>> Awesome. That would be great, thanks.
> 
> That does mean I need a) all of the Maintainer Acks and b) you to tell
> me which ones need to go through a single tree.
> 

You need to take patches 1 to 6 in the MFD tree. Out of these, patches 1 to 4
need to be shared with Tony as an immutable branch.

Tony, could you please Ack patches 1 to 4? Thanks.

cheers,
-roger
