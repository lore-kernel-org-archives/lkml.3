Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3CTLCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:02:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34032 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3CTLCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:02:35 -0400
Message-ID: <51499748.8020700@monstr.eu>
Date: Wed, 20 Mar 2013 12:02:32 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Tejun Heo <tj@kernel.org>, James Hogan <james.hogan@imgtec.com>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memblock: Kill ARCH_POPULATES_NODE_MAP once more
References: <1363775108.1390.88.camel@x61.thuisdomein>
In-Reply-To: <1363775108.1390.88.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 11:25 AM, Paul Bolle wrote:
> The Kconfig symbol ARCH_POPULATES_NODE_MAP was killed in v3.3. After
> that it popped up again in microblaze and metag. Nobody noticed,
> probably because these Kconfig symbols are entirely unused and these
> architectures both select HAVE_MEMBLOCK_NODE_MAP. Anyhow, these two
> entries can also be killed.

Ah. We have done the developing on that on earlier version and
to mainline it went in 3.3 merge window that's why I didn't notice it.

If James wants to take this patch through his tree, I am ok with that
and here is my

Acked-by: Michal Simek <monstr@monstr.eu>

Or if you want to take this through my microblaze tree, I am also ok
with that but please send me your ACK.

Thanks for this patch,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
