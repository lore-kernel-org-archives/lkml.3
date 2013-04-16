Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3DPPNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:13:44 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56994 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750Ab3DPPNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE2D0FB04F2B@SC-VEXCH4.marvell.com>
References: <1365651463-11502-1-git-send-email-zhangwm@marvell.com>
	<1365651463-11502-2-git-send-email-zhangwm@marvell.com>
	<CAN1soZwFJybMUZgxZJyXcDdKXbpQxaVntyZd8oGnQivLF=ZNNA@mail.gmail.com>
	<175CCF5F49938B4D99B2E3EF7F558EBE2D0FB04F2B@SC-VEXCH4.marvell.com>
Date: Tue, 16 Apr 2013 23:13:41 +0800
Message-ID: <CAN1soZxWkXn4CxJEgZFQHc0MY6Arq2UfpvOEhJ5ZrTKOT=rw4g@mail.gmail.com>
Subject: Re: [PATCH 1/4] ARM: mmp: add wakeup function for ICU
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > From: Haojian Zhuang [mailto:haojian.zhuang@gmail.com]
>> > Sent: 2013年4月13日 20:50
>> > To: Neil Zhang
>> > Cc: Grant Likely; linux-arm-kernel@lists.infradead.org;
>> > linux-kernel@vger.kernel.org; Chao Xie
>> > Subject: Re: [PATCH 1/4] ARM: mmp: add wakeup function for ICU
>> >
>> > On Thu, Apr 11, 2013 at 11:37 AM, Neil Zhang <zhangwm@marvell.com>
>> > wrote:
>> > > From: Chao Xie <chao.xie@marvell.com>
>> > >
>> > > PXA988 will use GIC as its interrupt controller, and ICU is used as
>> > > wakeup logic. When AP subsystem is powered off, GIC will lose its
>> > > context, the PMU will need ICU to wakeup the AP subsystem.
>> > > When ICU works as wakeup logic, there is no need to know
>> > > intc-nr-irqs, change the corresponding code.
>> > >
>> > > Signed-off-by: Chao Xie <chao.xie@marvell.com>
>> > > Signed-off-by: Neil Zhang <zhangwm@marvell.com>
>> > > ---
>> >
>> > Since it's totally different from original ICU irq initialization, I
>> > suggest to create a new entry to handle this kind of wakeup event. And
>> > we could create a new mask/unmask function.
>>
>> Ok, I'll update it.
> Are you OK if use icu_mask_irq_wakeup / icu_unmask_irq_wakeup for the new functions.

Yes, it's ok to me.
