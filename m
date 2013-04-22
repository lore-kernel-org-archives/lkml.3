Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3DVKHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:07:43 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:61052 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3DVKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130422055612.GE6081@intel.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130415163618.GF12436@intel.com>
	<1366114487.7932.29.camel@smile>
	<1525811.597RVDyDxu@vostro.rjw.lan>
	<20130422055612.GE6081@intel.com>
Date: Mon, 22 Apr 2013 13:07:39 +0300
Message-ID: <CAHp75Ve+c01kSoOwUSW=D9tq+svuOTzkkEhM0Amn1vL9VdiXWg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] dmaengine: add ACPI DMA helpers and use them in dw_dmac
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 8:56 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, Apr 16, 2013 at 08:11:57PM +0200, Rafael J. Wysocki wrote:
>> On Tuesday, April 16, 2013 03:14:47 PM Andy Shevchenko wrote:
>> > On Mon, 2013-04-15 at 22:06 +0530, Vinod Koul wrote:
>> > > On Tue, Apr 09, 2013 at 02:05:42PM +0300, Andy Shevchenko wrote:
>> > > > There is a patch series which introduces ACPI DMA helpers in similar way like
>> > > > we have for DeviceTree.
>> > > >
>> > > > In addition it applies this to the first user, namely dw_dmac driver.
>> > > Applied w/o 3 & 5.2 they failed, can you pls rebase and resend
>> > >
>> >
>> > Actually those two (at least 5/5) can't be applied on top of slave-dma.
>> > The patches requires slave-dma and linux-pm together. I heard it's
>> > usually achieved by creating a specific branch in one subsystem
>> > (linux-pm in our case) for another.
>> >
>> > Rafael, what could we do here?
>>
>> I suppose Vinod can pull from my acpi-lpss (which is guaranteed not to be
>> rebased at this point) and apply the series on top of that.
> Or I can wait for rc1 and apply afterwards...?

Mika and I have no objections to go this way.

--
With Best Regards,
Andy Shevchenko
