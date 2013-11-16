Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3KPJju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 04:39:50 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:39764 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab3KPJjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 04:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAHp75Vf3CJNgSiSjoZ6dYjRRHWN4bTpMxRTLG37+wwtEsQbq4g@mail.gmail.com>
References: <52864BBC.7000506@koalo.de>
	<1384537403.14845.131.camel@smile>
	<20131115175155.GQ16735@n2100.arm.linux.org.uk>
	<CAHp75Vf3CJNgSiSjoZ6dYjRRHWN4bTpMxRTLG37+wwtEsQbq4g@mail.gmail.com>
Date: Sat, 16 Nov 2013 11:39:43 +0200
Message-ID: <CAHp75VdvfABJ5C9M4F_RbfGfR5cp8xROzRTCgtkMUvUxoHXS0Q@mail.gmail.com>
Subject: Re: [PATCHv5] dmaengine: Add support for BCM2835
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Florian Meier <florian.meier@koalo.de>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Nov 15, 2013 at 7:51 PM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>
>> On Fri, Nov 15, 2013 at 05:43:45PM +0000, Shevchenko, Andriy wrote:
>>
>> > > +module_platform_driver(bcm2835_dma_driver);
>> >
>> > Is it possible to get driver initialized after that one that uses it?
>>
>> Doesn't quite make sense.  If you're asking whether other drivers can
>> try to make use of this driver before it's initialised, then the answer
>> is no.  We have mechanisms to cope with that - see deferred probing.

The reason why I was asking about I'm just wondering what we have to
do with existing drivers. Shall we convert them to be initialized as
normal platform drivers instead of subsys_initcall?

-- 
With Best Regards,
Andy Shevchenko
