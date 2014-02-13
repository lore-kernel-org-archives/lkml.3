Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaBMSnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 13:43:23 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62215 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaBMSnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 13:43:19 -0500
Message-ID: <52FD1243.9040706@gmail.com>
Date: Thu, 13 Feb 2014 20:43:15 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pavel Machek <pavel@ucw.cz>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [BISECTED] ssh - Received disconnect from x.x.x.x: 2: Bad packet
 length 3149594624
References: <52FD08D1.3030405@gmail.com> <20140213182105.GN13576@mudshark.cambridge.arm.com>
In-Reply-To: <20140213182105.GN13576@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13.02.2014 20:21, Will Deacon wrote:
>
> That's certainly unexpected. The n900 has (iirc) a Cortex-A8, which as an
> ARMv7 core, can perform unaligned accesses to normal, cacheable memory in
> hardware.
>

Yep, Cortex-A8 and it has no problem to do unaligned memory accesses 
AFAIK. I suspect it is a driver issue, not CPU.

> Can you provide your .config and/or any information about your network chip
> please? There's a chance that the driver is doing something odd.

The chip is TI wl1251, you can find the config file here(actually this 
is the tree I am using to boot 3.14-rc1 on N900) - 
https://gitorious.org/linux-n900/freemangordons-linux-n900/source/1434dbd7fbc5ec257b6cd6c547689b79177d1937:arch/arm/configs/rx51_defconfig

Thanks,
Ivo
