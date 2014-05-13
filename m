Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaEMRCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:02:19 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52695 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaEMRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:02:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140513152233.GB27822@titan.lakedaemon.net>
References: <1399940993-1773-1-git-send-email-robherring2@gmail.com>
	<1399940993-1773-6-git-send-email-robherring2@gmail.com>
	<20140513152233.GB27822@titan.lakedaemon.net>
Date: Tue, 13 May 2014 12:02:06 -0500
Message-ID: <CAL_JsqJuYwkyy0UO75D1XmAKZa3ui3zYYBi55xFOWUFVgFw5=g@mail.gmail.com>
Subject: Re: [PATCH 5/7] irqchip: s3c24xx: fix function type for IRQCHIP_OF_DECLARE
From: Rob Herring <robherring2@gmail.com>
To: Jason Cooper <jason@lakedaemon.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 10:22 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> Rob,
>
> On Mon, May 12, 2014 at 07:29:51PM -0500, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Adding function type checking to IRQCHIP_OF_DECLARE found a type mismatch
>> with s3c2410_init_intc_of and s3c2416_init_intc_of. The function only takes
>> the 1st 2 parameters.
>>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  drivers/irqchip/irq-s3c24xx.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> Thomas has asked me to give him a hand with the patches for
> drivers/irqchip.  When you add these two to your tree, could you amend
> the subject line to conform with the other patches in that directory?

Excellent! We've needed some help there for a long time. Is there a
patch in flight to add this to MAINTAINERS.

> eg (note the capitalization on 'Fix'):
>
>   irqchip: s3c24xx: Fix function type for IRQCHIP_OF_DECLARE
>   irqchip: mxs: Fix function type for IRQCHIP_OF_DECLARE

Will do.

>
> With that change,
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
>
> Or, if you like, I can apply these two to the branch I'm staging for
> Thomas.  Either is fine with me.
>
> thx,
>
> Jason.
