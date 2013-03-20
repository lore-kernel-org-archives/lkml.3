Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3CTNHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 09:07:48 -0400
Received: from multi.imgtec.com ([194.200.65.239]:47722 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab3CTNHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 09:07:47 -0400
Message-ID: <5149B486.9050406@imgtec.com>
Date: Wed, 20 Mar 2013 13:07:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: <monstr@monstr.eu>, Tejun Heo <tj@kernel.org>,
        <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Kill ARCH_POPULATES_NODE_MAP once more
References: <1363775108.1390.88.camel@x61.thuisdomein> <51499748.8020700@monstr.eu>
In-Reply-To: <51499748.8020700@monstr.eu>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_20_13_07_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/13 11:02, Michal Simek wrote:
> On 03/20/2013 11:25 AM, Paul Bolle wrote:
>> The Kconfig symbol ARCH_POPULATES_NODE_MAP was killed in v3.3. After
>> that it popped up again in microblaze and metag. Nobody noticed,
>> probably because these Kconfig symbols are entirely unused and these
>> architectures both select HAVE_MEMBLOCK_NODE_MAP. Anyhow, these two
>> entries can also be killed.
> 
> Ah. We have done the developing on that on earlier version and
> to mainline it went in 3.3 merge window that's why I didn't notice it.
> 
> If James wants to take this patch through his tree, I am ok with that
> and here is my
> 
> Acked-by: Michal Simek <monstr@monstr.eu>
> 
> Or if you want to take this through my microblaze tree, I am also ok
> with that but please send me your ACK.

Thanks for the patch Paul. This was added to metag when we were on
2.6.34. I spotted the adding of HAVE_MEMBLOCK_NODE_MAP to SH in v3.3 and
did the same for metag, but didn't notice the removal of
ARCH_POPULATES_NODE_MAP.

I'm happy to take this patch for v3.10.

Cheers
James

