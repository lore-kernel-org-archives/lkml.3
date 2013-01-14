Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab3ANL24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:28:56 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43889 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab3ANL2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:28:54 -0500
Message-ID: <50F3EBEF.8040809@ti.com>
Date: Mon, 14 Jan 2013 13:28:47 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 01/14] mfd: omap-usb-host: Consolidate OMAP USB-HS platform
 data
References: <1357836694-30788-1-git-send-email-rogerq@ti.com> <1357836694-30788-2-git-send-email-rogerq@ti.com> <20130110234537.GB15458@atomide.com> <50EFDE10.9080902@ti.com> <20130111181331.GM14149@atomide.com>
In-Reply-To: <20130111181331.GM14149@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 08:13 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130111 01:43]:
>> Tony,
>>
>> On 01/11/2013 01:45 AM, Tony Lindgren wrote:
>>> * Roger Quadros <rogerq@ti.com> [130110 08:54]:
>>>> Let's have a single platform data structure for the OMAP's High-Speed
>>>> USB host subsystem instead of having 3 separate ones i.e. one for
>>>> board data, one for USB Host (UHH) module and one for USB-TLL module.
>>>>
>>>> This makes the code much simpler and avoids creating multiple copies of
>>>> platform data.
>>>
>>> I can apply just this patch alone into an immutable branch that
>>> we all can merge in as needed as long as we have acks for the USB
>>> and MFD parts.
>>>
>>> Or does this one need to be changed based on Alan's comments
>>> on the EHCI lib related changes?
>>>
>>
>> This does not depend on EHCI lib based changes but it depends on the
>> OMAP USB Host cleanup series posted earlier.
> 
> Can we first apply just the minimal platform_data + board file + clock
> changes?
> 
We could, but I'll then have to make changes to the patches in the first
series and re-post them. Do you want me to do that?

> That way I can apply those to some immutable tree for everybody to use,
> and we cut off the dependency to the driver changes for the rest of the
> patches. And then I'm off the hook for the rest of the patches :)
> 

Or you could just ack this patch ;). The platform data is specific to
USB host only :)

--
cheers,
-roger
