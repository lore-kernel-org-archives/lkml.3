Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3CYJKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 05:10:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39220 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab3CYJKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 05:10:17 -0400
Message-ID: <515014A4.5020504@ti.com>
Date: Mon, 25 Mar 2013 14:41:00 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com> <51406BA7.8010306@arm.com> <51407120.7030709@ti.com> <51417E58.5050501@ti.com> <20130315050014.GA15706@tiny-lites> <5146B972.1010002@ti.com> <20130318150724.GC28585@mudshark.cambridge.arm.com> <514736D4.4070906@ti.com> <20130318170649.GA29585@mudshark.cambridge.arm.com> <5148082A.3060503@ti.com> <20130319102803.GB22452@mudshark.cambridge.arm.com>
In-Reply-To: <20130319102803.GB22452@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Tuesday 19 March 2013 03:58 PM, Will Deacon wrote:
> On Tue, Mar 19, 2013 at 06:39:38AM +0000, Santosh Shilimkar wrote:
>> On Monday 18 March 2013 10:36 PM, Will Deacon wrote:

[..]

>>> Well, we could just add the warn_once prints but that doesn't stop debug
>>> from breaking after the first pm/suspend/hotplug operation.
>>>
>> Probably we should drop the $subject patch approach and use warn_once
>> at least for current rc. Ofcourse it doesn't help to get working
>> hw_breakpoint support. Patch end of the email with warn_once.
> 
> Yeah, I'll merge that, but it's a real shame that this breaks hardware debug
> on one of the few platforms where it was reported to work.
> 
Are you going to send the patch for 3.9-rcx ? As I said before without the
patch OMAP4 CPUILDE is unusable because of that debug noise and hence it
will be good to get that patch in

Regards,
Santosh
