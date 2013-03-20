Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3CTOAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:00:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab3CTOAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <5149B486.9050406@imgtec.com>
References: <1363775108.1390.88.camel@x61.thuisdomein>
	<51499748.8020700@monstr.eu>
	<5149B486.9050406@imgtec.com>
Date: Wed, 20 Mar 2013 15:00:06 +0100
Message-ID: <CAHTX3d+ds9Cb0Z6hpDWa5cJwqR9U=N1z4KFWKTuxvxfcywSeLA@mail.gmail.com>
Subject: Re: [PATCH] memblock: Kill ARCH_POPULATES_NODE_MAP once more
From: Michal Simek <monstr@monstr.eu>
To: James Hogan <james.hogan@imgtec.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Tejun Heo <tj@kernel.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/20 James Hogan <james.hogan@imgtec.com>:
> On 20/03/13 11:02, Michal Simek wrote:
>> On 03/20/2013 11:25 AM, Paul Bolle wrote:
>>> The Kconfig symbol ARCH_POPULATES_NODE_MAP was killed in v3.3. After
>>> that it popped up again in microblaze and metag. Nobody noticed,
>>> probably because these Kconfig symbols are entirely unused and these
>>> architectures both select HAVE_MEMBLOCK_NODE_MAP. Anyhow, these two
>>> entries can also be killed.
>>
>> Ah. We have done the developing on that on earlier version and
>> to mainline it went in 3.3 merge window that's why I didn't notice it.
>>
>> If James wants to take this patch through his tree, I am ok with that
>> and here is my
>>
>> Acked-by: Michal Simek <monstr@monstr.eu>
>>
>> Or if you want to take this through my microblaze tree, I am also ok
>> with that but please send me your ACK.
>
> Thanks for the patch Paul. This was added to metag when we were on
> 2.6.34. I spotted the adding of HAVE_MEMBLOCK_NODE_MAP to SH in v3.3 and
> did the same for metag, but didn't notice the removal of
> ARCH_POPULATES_NODE_MAP.
>
> I'm happy to take this patch for v3.10.

Ok. Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
