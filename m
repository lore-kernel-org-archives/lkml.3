Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaDYJc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:32:26 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:54475 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbaDYJcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <1398375234.2708.122.camel@adam.happyassassin.net>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	<CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	<5353A1F6.60602@linux.intel.com>
	<5353B8A4.1080900@linux.intel.com>
	<1398007690.2674.0.camel@adam.happyassassin.net>
	<5354BA59.2000008@linux.intel.com>
	<53551D0F.40906@linux.intel.com>
	<CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
	<1398230210.2704.8.camel@adam.happyassassin.net>
	<20140423083430.GV30677@intel.com>
	<20140423122344.GX30677@intel.com>
	<5359120E.2030007@linux.intel.com>
	<1398375234.2708.122.camel@adam.happyassassin.net>
Date: Fri, 25 Apr 2014 11:32:17 +0200
Message-ID: <CACRpkdasjd2HGR199_aqhemAnJD5z6--=Rr=tSoJX_hJ6-ukFA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
From: Linus Walleij <linus.walleij@linaro.org>
To: Adam Williamson <awilliam@redhat.com>
Cc: "Jin, Yao" <yao.jin@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Alan Cox <alan@linux.intel.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:33 PM, Adam Williamson <awilliam@redhat.com> wrote:

> Well, I just ran another test too. I built a kernel (3.15rc2) with both
> v3 of Doug's SDIO device enumeration patch -
> http://dougvj.net/baytrail_gpio_quirk_v3.patch - and the new patch for
> the IRQ allocation issue by Thomas Gleixner,
> https://patchwork.kernel.org/patch/4051581/ . That kernel gives me a
> working touchscreen. Note that
> http://dougvj.net/baytrail_gpio_quirk_v3.patch includes both the blocks
> you mention (i.e. it adds INT33FC in both places).
>
> So, it really seems like for me at least, it's the combination of Doug's
> patch and your approach to fixing the IRQ allocation issue that breaks
> the touchscreen. Thomas' approach, even combined with Doug's patch,
> seems to work fine.

Please make sure to provide a Tested-by: tag to Thomas so he
knows this is merge material.

Yours,
Linus Walleij
