Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3BMJJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:09:37 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45395 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3BMJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:09:34 -0500
MIME-Version: 1.0
In-Reply-To: <20130213083218.GA2426@arwen.pp.htv.fi>
References: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
	<1e3101ce09b3$b2e178c0$18a46a40$@kernel.org>
	<20130213083218.GA2426@arwen.pp.htv.fi>
Date: Wed, 13 Feb 2013 14:39:32 +0530
Message-ID: <CAFp+6iEfVSbyGVNhDFc2wW7w=ZMGwVpcc28GAGOgHffCWQRLMQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] Adding USB 3.0 DRD-phy support for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: kgene@kernel.org, linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        tomasz.figa@gmail.com, av.tikhomirov@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>, sylvester.nawrocki@gmail.com,
        rob.herring@calxeda.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 2:02 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Feb 12, 2013 at 10:31:00PM -0800, kgene@kernel.org wrote:
>> Vivek Gautam wrote:
>> >
>> > Based on 'usb-next'
>> >
>> > Changes from v4:
>> >  - Modifying function names and driver names to follow a common
>> >    naming convention.
>> >         "usb2phy" for samsung-usb2phy driver
>> >         "usb3phy" for samsung-usb3phy driver
>> >  - Changing file names "samsung-usb2.c" to "samsung-usb2phy.c" and,
>> >    "samsung-usb3.c" to "samsung-usb3phy.c"
>> >  - Removing dependencies for SAMSUNG_USB2PHY and
>> > SAMSUNG_USB3PHY.
>> >  - Arranging SAMSUNG_USB2PHY and SAMSUNG_USB3PHY to select
>> > SAMSUNG_USBPHY,
>> >    which is the usb-phy helper driver.
>> >
>> > Vivek Gautam (2):
>> >   usb: phy: samsung: Common out the generic stuff
>> >   usb: phy: samsung: Add PHY support for USB 3.0 controller
>> >
>> >  drivers/usb/phy/Kconfig           |   25 +-
>> >  drivers/usb/phy/Makefile          |    2 +
>> >  drivers/usb/phy/samsung-usb2phy.c |  511
>> > ++++++++++++++++++++++++++
>> >  drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
>> >  drivers/usb/phy/samsung-usbphy.c  |  717
>> +------------------------------------
>> >  drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
>> >  6 files changed, 1219 insertions(+), 713 deletions(-)
>> >  create mode 100644 drivers/usb/phy/samsung-usb2phy.c
>> >  create mode 100644 drivers/usb/phy/samsung-usb3phy.c
>> >  create mode 100644 drivers/usb/phy/samsung-usbphy.h
>> >
>> > --
>> > 1.7.6.5
>>
>> For now, looks good to me, and if any enhancement is required, it can be
>> done next time.
>>
>> Felipe, please go ahead with my ack :-)
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>
> Thank you, but it's too late for v3.9, this will have to wait until
> v3.10. You will get an email once I apply these to my branch.
>
Sure, thanks :)


-- 
Thanks & Regards
Vivek
