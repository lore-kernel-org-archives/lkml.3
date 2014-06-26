Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbaFZQs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 12:48:27 -0400
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:48322 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757085AbaFZQs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:48:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406260302510.5170@nanos>
References: <1403734041-5112-1-git-send-email-fkan@apm.com>
	<1403734041-5112-3-git-send-email-fkan@apm.com>
	<alpine.DEB.2.10.1406260302510.5170@nanos>
Date: Thu, 26 Jun 2014 09:48:25 -0700
Message-ID: <CAL85gmAPXDTO2x4esYNq1ZHUAwuNTtMCNtc+ODwnrNPEaDH_1w@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] irqchip: gic: preserve gic V2 bypass bits in cpu
 ctrl register
From: Feng Kan <fkan@apm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: jason <jason@lakedaemon.net>, Marc Zyngier <marc.zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Vinayak Kale <vkale@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 6:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 25 Jun 2014, Feng Kan wrote:
>
>> This change is made to preserve the GIC v2 bypass bits in the
>> GIC_CPU_CTRL register (also known as the GICC_CTLR register in spec).
>> This code will preserve all bits configured by the bootloader regarding
>> v2 bypass group bits. In the X-Gene platform, the bypass functionality
>> is not used and bypass bits should not be changed by the kernel gic
>> code as it could lead to incorrect behavior.
>>
>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>
> Who wrote the patch? According to the SOB chain it's Vinayak, but your
> patch is missing the:
I wrote the patch which was based on Vinayak's original change. I can
change it to
Reviewed-by. I was trying to give him credit.

>
> From: Vinayak Kale <vkale@apm.com>
>
> before the actual changelog starts.
