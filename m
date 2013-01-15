Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab3AOOju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:39:50 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34116 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3AOOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:39:49 -0500
Message-ID: <50F56A1A.3040504@ti.com>
Date: Tue, 15 Jan 2013 20:09:22 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <b-cousson@ti.com>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] usb: musb: add driver for control module
References: <1358239378-10030-1-git-send-email-kishon@ti.com> <201301151341.08297.arnd@arndb.de>
In-Reply-To: <201301151341.08297.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tuesday 15 January 2013 07:11 PM, Arnd Bergmann wrote:
> On Tuesday 15 January 2013, Kishon Vijay Abraham I wrote:
>> Added a new driver for the usb part of control module. This has an API
>> to power on the USB2 phy and an API to write to the mailbox depending on
>> whether MUSB has to act in host mode or in device mode.
>>
>> Writing to control module registers for doing the above task which was
>> previously done in omap glue and in omap-usb2 phy is removed.
>>
>> Also added the dt data to get MUSB working in OMAP platforms.
>> This series has patches for both drivers and ARCH folders, so If it has to
>> be split I'll do it.
>>
>
> The series looks good to me, I just had a minor comment on one patch.
>
> One a somewhat related topic, I wonder whether there are any plans
> on your side to change this driver to support multiple bus glues
> to be built for one kernel image. With a multiplatform kernel, we
> may need all of TUSB6010/OMAP2PLUS/DSPS/UX500 for instance.

We don't have plans as of now. I actually don't expect any changes in 
the driver other than the Kconfig changes. Anyways the probe of glue's 
other than the platform it's running won't get called. right Felipe?

Thanks
Kishon
