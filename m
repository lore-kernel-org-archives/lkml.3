Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab3EWLH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:07:57 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35253 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082Ab3EWLH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:07:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130523101919.GB30200@intel.com>
References: <1368003349-12204-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130514045423.GC27639@intel.com>
	<1369128579.29283.139.camel@smile>
	<20130523101919.GB30200@intel.com>
Date: Thu, 23 May 2013 14:07:54 +0300
Message-ID: <CAHp75Vctb1kR8gUQk0vu8scsgjBtZUq9DS0NQ+zVOPAobG0QOw@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] dma: support Lynxpoint DMA
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 1:19 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Tue, May 21, 2013 at 12:29:39PM +0300, Andy Shevchenko wrote:
>> On Tue, 2013-05-14 at 10:24 +0530, Vinod Koul wrote:
>> > On Wed, May 08, 2013 at 11:55:47AM +0300, Andy Shevchenko wrote:
>> > > This is the rest of patch series related to ACPI DMA helpers and Lynxpoint DMAC.
>> > > Patches are rebased against current Linus' tree and Vinod's branch for-linus.
>> > >
>> > > Since v2:
>> > >  - remove patches that are already in the Vinod's tree
>> > >  - rebase on top of today's origin/master and Vinod's for-linus branch
>> > >  - fix description in patch 2/2
>> > Applied both, Thanks
>>
>> Thank you for applying them to next.
>>
>> I'm just wondering if you are going to send pull request soon to get
>> them in the v3.10-rcX.
> Nope these are in next & would show up in Linus's tree in next merge window.
> Something which is not a bug fix doesnt get merged in rc's. You should know the
> process

Hmm... Now we have a situation when v3.9.x has support of Lynxpoint
DMA, v3.10-rc2 has it broken.
As far as I remember our discussion [1]  we agreed to wait for
v3.10-rc1 due to merge of linux-pm patches.

For us it sounds like a regression.

[1] https://lkml.org/lkml/2013/4/22/34

--
With Best Regards,
Andy Shevchenko
