Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab3APHR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:17:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3APHR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:17:26 -0500
Message-ID: <50F653F2.90903@gmail.com>
Date: Wed, 16 Jan 2013 01:17:06 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: "arm@kernel.org" <arm@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] irqchip init infrastructure and GIC/VIC move
References: <50F19F3D.60502@gmail.com> <CAOesGMgrAdvRqrnanfRD1gvJ-4O6pT1n2ZR+TCZADjD1ED_+UA@mail.gmail.com>
In-Reply-To: <CAOesGMgrAdvRqrnanfRD1gvJ-4O6pT1n2ZR+TCZADjD1ED_+UA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 09:56 PM, Olof Johansson wrote:
> On Sat, Jan 12, 2013 at 9:37 AM, Rob Herring <robherring2@gmail.com> wrote:
>> Arnd, Olof,
>>
>> Please pull for 3.9. This is the initial infrastructure and conversion
>> of the GIC and VIC to use it. Several people are waiting for the irqchip
>> infrastructure to go in in order to convert other irqchip code over.
>>
>> I've left "static asmlinkage" in on the irq handlers. There's been no
>> more discussion, so I think we are in agreement. If asmlinkage defines
>> the procedure call convention for assembly calls, then it still makes
>> sense to have it on a static function called thru a function pointer.
>>
>> Rob
>>
>> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
>>
>>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
>>
>> are available in the git repository at:
>>
>>   git://sources.calxeda.com/kernel/linux.git tags/gic-vic-to-irqchip
> 
> Ugh. This conflicts heavily with the timer cleanup from Stephen, due
> to adjacent changes in the machine descriptors.
> 
> I fixed them up, but I would appreciate a second glance at them for
> sanity checking.

Sorry about that. It all looks correct to me.

Rob

