Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaBXXDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:03:42 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48509 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaBXXDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:03:40 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402242306060.21251@ionos.tec.linutronix.de>
References: <21860356.103351393198399120.JavaMail.weblogic@epml01>
 <CAErSpo5WW4=aL_BqhnrG+J1Xq=FVtdu0BWkHUyeiOrbBhqmYwg@mail.gmail.com> <alpine.DEB.2.02.1402242306060.21251@ionos.tec.linutronix.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Feb 2014 16:03:19 -0700
Message-ID: <CAErSpo4doDT7TC5ACxnizWJFTq+8N1Q3Y8F9_oosTg6w0GQfCA@mail.gmail.com>
Subject: Re: [patch 07/26] pci: pcie-designware: Remove irq_desc abuse
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mohit Kumar <mohit.kumar@st.com>, pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 3:06 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 24 Feb 2014, Bjorn Helgaas wrote:
>> On Sun, Feb 23, 2014 at 4:33 PM, Jingoo Han <jg1.han@samsung.com> wrote:
>> > On Monday, February 24, 2014 6:40 AM, Thomas Gleixner wrote:
>> >>
>> >> There is no reason to care about irq_desc in that context, escpecially
>> >> as irq_data for that interrupt is retrieved as well.
>> >>
>> >> Use the proper accessor for the msi descriptor
>> >>
>> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> >> Cc: Jingoo Han <jg1.han@samsung.com>
>> >> Cc: Mohit Kumar <mohit.kumar@st.com>
>> >> Cc: pci <linux-pci@vger.kernel.org>
>> >
>> > Acked-by: Jingoo Han <jg1.han@samsung.com>
>>
>> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Thomas, I assume you'll merge this along with the rest of your series.
>>  I don't have any pending changes in this area.
>
> I can do, but it does not depend on anything else, so you can pick it
> up as well. Either way is fine.

I never know what to do with these.  I suggested that you pick it up
so the whole series would be together, because I assumed it would make
more sense in the git history to have all these similar changes
grouped together.  But maybe that really doesn't matter.

What's the recommended practice?

Bjorn
