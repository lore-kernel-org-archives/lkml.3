Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3HEPBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:01:46 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:51569 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3HEPBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:01:43 -0400
Date: Mon, 5 Aug 2013 11:01:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-arch@vger.kernel.org
Subject: Re: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
Message-ID: <20130805150127.GC19631@mtj.dyndns.org>
References: <20130629175743.GA382@mtj.dyndns.org>
 <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com>
 <20130629195549.GE3353@n2100.arm.linux.org.uk>
 <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com>
 <51D18DBA.6090608@ti.com>
 <51F1A7AA.8080700@ti.com>
 <20130725223658.GJ26107@mtj.dyndns.org>
 <51F1B17F.30902@ti.com>
 <20130726030812.GB30195@mtj.dyndns.org>
 <51FC1F3A.8090201@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC1F3A.8090201@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 02, 2013 at 05:06:02PM -0400, Santosh Shilimkar wrote:
> Looking at the situation, how about proceeding with patch updating
> the bootmem API signatures to use phys_addr_t  which can unblock me
> to get my machine working.

I'm not sure about that.  No matter how you play it, it'll end up
duplicating memblock interface.

> Introduction of new API, conversions of core kernel code and then

What new API are we talking about?  Wasn't the plan to convert core
kernel code to use memblock and let bootmem emulate bootmem API?
There's no new API.

> arches moving away from bootmem is going to take significant time

And arches moving away from bootmem doesn't have to happen now.

> anyways. I will continue my effort to get ARM port moved to no-bootmem
> and get that merged.

Thanks.

-- 
tejun
