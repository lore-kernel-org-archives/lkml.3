Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab3ARLzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:55:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60219 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3ARLzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:55:42 -0500
Message-ID: <50F93813.4010107@ti.com>
Date: Fri, 18 Jan 2013 17:24:59 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <b-cousson@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <horms@verge.net.au>,
        <magnus.damm@gmail.com>, <cbou@mail.ru>, <dwmw2@infradead.org>,
        <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <leoli@freescale.com>, <eric.y.miao@gmail.com>,
        <haojian.zhuang@gmail.com>, <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 0/6] USB: Add multiple PHYs of same type
References: <1358348462-27693-1-git-send-email-kishon@ti.com> <20130118114859.GC4379@arwen.pp.htv.fi>
In-Reply-To: <20130118114859.GC4379@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 05:18 PM, Felipe Balbi wrote:
> On Wed, Jan 16, 2013 at 08:30:56PM +0530, Kishon Vijay Abraham I wrote:
>> New platforms are being added which has multiple PHY's (of same type) and
>> which has multiple USB controllers. The binding information has to be
>> present in the PHY library (otg.c) in order for it to return the
>> appropriate PHY whenever the USB controller request for the PHY. So
>> added a new API to pass the binding information. This API should be
>> called by platform specific initialization code.
>>
>> So the binding should be done something like
>> usb_bind_phy("musb-hdrc.0.auto", 0, "omap-usb2.1.auto"); specifying the USB
>> controller device name, index, and the PHY device name.
>> I have done this binding for OMAP platforms, but it should be done for
>> all the platforms.
>>
>> After this design, the phy can be got by passing the USB controller device
>> pointer and the index.
>>
>> Developed this patch series on
>> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git xceiv
>> after applying "usb: musb: add driver for control module" patch series.
>>
>> Did basic enumeration testing in omap4 panda, omap4 sdp and omap3 beagle.
>
> please resend without RFC so I can apply.

I'll resend after addressing Roger's comments in a while.

Thanks
Kishon
