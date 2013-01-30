Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3A3FwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 00:52:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33140 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3A3Fvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 00:51:53 -0500
Message-ID: <5108B532.6000706@ti.com>
Date: Wed, 30 Jan 2013 11:22:50 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ruslan Bilovol <ruslan.bilovol@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/2] ARM: kernel: update cpuinfo to print CPU model
 name
References: <1359474865-15408-1-git-send-email-ruslan.bilovol@ti.com> <1359474865-15408-2-git-send-email-ruslan.bilovol@ti.com> <20130129160827.GJ2637@n2100.arm.linux.org.uk> <CAB=otbR+MA3NUhxqRdo=w81gz9sTLAsLV5ELcpp77UxizMiaKw@mail.gmail.com>
In-Reply-To: <CAB=otbR+MA3NUhxqRdo=w81gz9sTLAsLV5ELcpp77UxizMiaKw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 04:42 AM, Ruslan Bilovol wrote:
> Hi,
>
> On Tue, Jan 29, 2013 at 6:08 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Tue, Jan 29, 2013 at 05:54:24PM +0200, Ruslan Bilovol wrote:
>>> CPU implementer : 0x41
>>> CPU name        : OMAP4470 ES1.0 HS
>>
>> Sigh.  No.  Look at what you're doing - look carefully at the above.
>>
>> "CPU implementer" - 0x41.  That's A.  For ARM Ltd.  ARM Ltd implemented
>> this CPU.  Did ARM Ltd really implement OMAP4470 ?  I think TI would be
>> very upset if that were to be the case.
>
> Yes, it would be very surprisingly :)
>
>>
>> So no, OMAP4470 is _NOT_ a CPU.  It is a SoC.  The CPU inside the SoC is
>> a collection of ARM Ltd Cortex A9 _CPUs_.
>>
>> See?  Please, learn what a CPU is as opposed to a SoC.
>
> Completely agree with you. I will fix this
>
Thank god you agreed to drop your current approach. Please elaborate
what you are going to fix and also state what user-space features
changes from OMAP4460 to OMAP4470.

Regards,
Santosh



