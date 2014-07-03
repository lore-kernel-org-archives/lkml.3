Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaGCE7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 00:59:03 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:42545 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaGCE7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 00:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <53B3ED8E.3020503@ti.com>
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com>
	<CAFp+6iE9Wu-VrNUiu9VaFrEBdGyfnv0z23ME-x3WxUjJRWBt9g@mail.gmail.com>
	<53B3ED8E.3020503@ti.com>
Date: Thu, 3 Jul 2014 10:29:00 +0530
X-Google-Sender-Auth: Zk0msxeXnibOiaR1WvF1EEcLu_E
Message-ID: <CAFp+6iFyO=B6sgH91gGZOKUpJqoqnA4bnbOtgZgZnmWbHBF+Gw@mail.gmail.com>
Subject: Re: [PATCHv2 0/6] phy: simplified phy lookup
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jul 2, 2014 at 5:01 PM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> Hi,
>
> On Thursday 05 June 2014 06:51 PM, Vivek Gautam wrote:
>> Hi Heikki,
>>
>>
>> On Thu, Jun 5, 2014 at 6:22 PM, Heikki Krogerus
>> <heikki.krogerus@linux.intel.com> wrote:
>>> Hi,
>>>
>>> So the idea with these is that they should help to make it possible to
>>> request phys without caring about how they are mapped to the
>>> consumers, meaning, was is the mapping done in DT, ACPI, etc. Mapping
>>> phys to consumers can be now done with lookups similarly how clocks
>>> can be mapped in clkdev.c.
>>>
>>> Vivek needs to handle the phys of dwc3 also in xhci driver on
>>> Exynos5420 SoC, so I'm resending these now.
>>
>> Thank you so much for your efforts.
>> This will greatly help me in preparing the patches for PHY tuning.
>
> Can I get Tested-by please?

Sure,
I have tested this series with my phy-calibration patches. [1]
The entire lookup method looks fine.

Although i am re-working on my patches, but for this series -

Tested-by: Vivek Gautam <gautam.vivek@samsung.com>


[1] https://lkml.org/lkml/2014/6/6/202


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
