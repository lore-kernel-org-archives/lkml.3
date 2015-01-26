Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbbAZRXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:23:43 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:44057 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbbAZRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:23:41 -0500
MIME-Version: 1.0
In-Reply-To: <54C67267.3060406@nexus-software.ie>
References: <1422281727-32610-1-git-send-email-pure.logic@nexus-software.ie>
	<1422281727-32610-2-git-send-email-pure.logic@nexus-software.ie>
	<CAHp75VfAPjermaPYu2FwoRCycKsU48m=uXq=JqwQ6Bi31kV0hg@mail.gmail.com>
	<54C67267.3060406@nexus-software.ie>
Date: Mon, 26 Jan 2015 19:23:40 +0200
Message-ID: <CAHp75VcgUuUkfq0+W-Q5ab0Jm_i9syzvD=gC+Qd0_SX9L2LVqA@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] x86: Add Isolated Memory Regions for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 6:59 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> On 26/01/15 16:37, Andy Shevchenko wrote:

>> So, I mean if user enables this in the kernel config and runs rebuilt
>> kernel on the Quark it will work, will it?
>
>
> Yes. Do you mean to add a stronger comment indicating IMR is mandatory ?
> No issue with that.

No, it's just for my information.

>> If so, IMR is mandatory stuff or not? What else is mandatory?
> IMR is the only mandatory addition.

>> So, I'm not sure the above is a part of the patch. Would it be a prepend?
> Hmm - what do you mean by that ?

I mean first to introduce IMR files and then create the board entry in
the kernel config.

And it may contain the following as well (whatever is mandatory from it)

        depends on M586TSC
        select ARCH_REQUIRE_GPIOLIB
        select I2C

I took this snippet from BSP code.

-- 
With Best Regards,
Andy Shevchenko
