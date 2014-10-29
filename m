Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387AbaJ2KWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:22:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36702 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbaJ2KWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:22:20 -0400
Message-ID: <5450BFD8.7040307@arm.com>
Date: Wed, 29 Oct 2014 10:22:16 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, Phong Vo <pvo@apm.com>,
        Tin Huynh <tnhuynh@apm.com>, Y Vo <yvo@apm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Toan Le <toanle@apm.com>,
        Bjorn Andersson <bjorn@kryo.se>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] irqchip: GIC: Add support for irq_{get,set}_irqchip_state
References: <1414232097-4328-1-git-send-email-marc.zyngier@arm.com> <1414232097-4328-3-git-send-email-marc.zyngier@arm.com> <CACRpkdZJBWF=JPksecB4UNxcYtjhybAUprhWHkdHzMpb6gchJQ@mail.gmail.com>
In-Reply-To: <CACRpkdZJBWF=JPksecB4UNxcYtjhybAUprhWHkdHzMpb6gchJQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 29 Oct 2014 10:22:17.0607 (UTC) FILETIME=[373C3170:01CFF362]
X-MC-Unique: 114102910221802201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/10/14 10:14, Linus Walleij wrote:
> On Sat, Oct 25, 2014 at 12:14 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> 
>> Add the required hooks for the internal state of an interrupt
>> to be exposed to other subsystems.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> (...)
>> +static void gic_poke_irq(struct irq_data *d, u32 offset)
>> +static int gic_peek_irq(struct irq_data *d, u32 offset)
> 
> Awesome terminology Marc, very CBM BASIC v2 :)

Sorry Linus, I'm strictly an ORIC EXTENDED BASIC V1.0 kind of guy. :-)

	M.
-- 
Jazz is not dead. It just smells funny...

