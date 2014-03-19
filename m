Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbaCSX0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:26:55 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44263 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbaCSX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:26:53 -0400
MIME-Version: 1.0
In-Reply-To: <531908b6.44f8440a.03ab.0cce@mx.google.com>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
	<1394016605-24120-2-git-send-email-sebastian.capella@linaro.org>
	<531908b6.44f8440a.03ab.0cce@mx.google.com>
Date: Wed, 19 Mar 2014 16:26:52 -0700
Message-ID: <CADHgK6ssL=0XcM_shGmb9z1T3w5L5OWEJgs-v9VyT3=USwY4FQ@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] ARM: avoid tracers in soft_restart
From: Sebastian Capella <sebastian.capella@linaro.org>
To: Sebastian Capella <sebastian.capella@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        Steven Capper <steve.capper@linaro.org>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Robin Holt <robin.m.holt@gmail.com>, Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 March 2014 15:45, Sebastian Capella <sebastian.capella@linaro.org> wrote:
> Quoting Sebastian Capella (2014-03-05 02:50:04)
>> Use of tracers in local_irq_disable is causes recursive aborts when
>> called with irqs disabled and using a temporary stack (hibernation).
>> Replace local_irq_disable with raw_local_irq_disable instead to
>> avoid tracers.

> I have not heard any feedback on this change, since V3 of the
> patchset.
> Is everyone ok with this as it is?
> Thomas, thanks for proposing this, is this looking ok to you?

ping

I haven't received any further communication / acks on this particular
patch, since Russell's ~approval below:

On 26 February 2014 15:37, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Great, I'm happy with this now.  I assume that the plan is to submit this
>  to my patch system when everyone's given their fill of acks?

Is this ok as it is?

Thanks,

Sebastian
