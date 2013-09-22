Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab3IVNuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 09:50:52 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:40238 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab3IVNuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 09:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130922130056.GQ12758@n2100.arm.linux.org.uk>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
	<1379852488-32147-2-git-send-email-cinifr@gmail.com>
	<20130922130056.GQ12758@n2100.arm.linux.org.uk>
Date: Sun, 22 Sep 2013 21:50:50 +0800
Message-ID: <CAK3cCBzc8Ms03xLGsRaOtJikDw9Z3Tq3tWgh8VmkwVJGZU_BWg@mail.gmail.com>
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp
 support for Allwinner A20(sunxi 7i).
From: cinifr <cinifr@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: coosty@163.com,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "pawel.moll@arm.co" <pawel.moll@arm.co>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I get it, it is cause by using ./scripts/Lindent. I have to
remail patch aggin. :)

On 22 September 2013 21:00, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Sep 22, 2013 at 08:21:26PM +0800, Fan Rong wrote:
>> +.section ".text.head", "ax" ENTRY(sun7i_secondary_startup)
>> +msr cpsr_fsxc,
>> +#0xd3
>> +b secondary_startup ENDPROC(sun7i_secondary_startup)
>
> This looks like it's been messed up somehow.
>
