Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaCCJf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:35:28 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43450 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114AbaCCJf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:35:26 -0500
Message-ID: <53144CBC.2050607@ti.com>
Date: Mon, 3 Mar 2014 11:34:52 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <lee.jones@linaro.org>, <bcousson@baylibre.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v9 0/9] USB Host support for OMAP5 uEVM
References: <1393510711-4697-1-git-send-email-rogerq@ti.com> <20140228225627.GU13624@atomide.com>
In-Reply-To: <20140228225627.GU13624@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 03/01/2014 12:56 AM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [140227 06:21]:
>> Hi,
>>
>> This patchset brings up USB Host ports and Ethernet port on
>> the OMAP5 uEVM board.
>>
>> It also does some cleanup with respect to DT clock binding
>> for the mfd/omap-usb-host driver.
>>
>> Please queue these for -next.
>>
>> Lee,
>>
>> I've folded some platform data dependent patches with mfd patches
>> so that they don't break functionality when applied individually.
>> You can safely pull in all MFD patches (1 to 6).
>>
>> Tony & Benoit,
>>
>> Can you please accept patches 7, 8 and 9?
> 
> Are 7, 8 and 9 safe to queue separately from the MFD changes
> or do they need to wait for the MFD changes to get merged
> first?
> 

They are safe to queue separately.

cheers,
-roger
