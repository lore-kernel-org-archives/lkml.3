Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaGBLbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:31:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32770 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbaGBLbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:31:48 -0400
Message-ID: <53B3ED8E.3020503@ti.com>
Date: Wed, 2 Jul 2014 17:01:26 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv2 0/6] phy: simplified phy lookup
References: <1401972778-5880-1-git-send-email-heikki.krogerus@linux.intel.com> <CAFp+6iE9Wu-VrNUiu9VaFrEBdGyfnv0z23ME-x3WxUjJRWBt9g@mail.gmail.com>
In-Reply-To: <CAFp+6iE9Wu-VrNUiu9VaFrEBdGyfnv0z23ME-x3WxUjJRWBt9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 05 June 2014 06:51 PM, Vivek Gautam wrote:
> Hi Heikki,
> 
> 
> On Thu, Jun 5, 2014 at 6:22 PM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
>> Hi,
>>
>> So the idea with these is that they should help to make it possible to
>> request phys without caring about how they are mapped to the
>> consumers, meaning, was is the mapping done in DT, ACPI, etc. Mapping
>> phys to consumers can be now done with lookups similarly how clocks
>> can be mapped in clkdev.c.
>>
>> Vivek needs to handle the phys of dwc3 also in xhci driver on
>> Exynos5420 SoC, so I'm resending these now.
> 
> Thank you so much for your efforts.
> This will greatly help me in preparing the patches for PHY tuning.

Can I get Tested-by please?

Cheers
Kishon
