Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab3GZDIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:08:22 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:54186 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3GZDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:08:17 -0400
Date: Thu, 25 Jul 2013 23:08:12 -0400
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
Message-ID: <20130726030812.GB30195@mtj.dyndns.org>
References: <20130629152959.GB31339@mtj.dyndns.org>
 <20130629172123.GA3353@n2100.arm.linux.org.uk>
 <20130629175743.GA382@mtj.dyndns.org>
 <CAE9FiQXHuP-n0eZ9wN73V4nSvE+XEExDsx1t50_=YaW+V=LGLg@mail.gmail.com>
 <20130629195549.GE3353@n2100.arm.linux.org.uk>
 <CAE9FiQUoVNvWmmTV2+ZkU_nMxFToTHw6QLwp_Z_EjwMzqdLwuA@mail.gmail.com>
 <51D18DBA.6090608@ti.com>
 <51F1A7AA.8080700@ti.com>
 <20130725223658.GJ26107@mtj.dyndns.org>
 <51F1B17F.30902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F1B17F.30902@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 25, 2013 at 07:15:11PM -0400, Santosh Shilimkar wrote:
> Sorry if I wasn't clear before, but I need help to at least have new
> memblock API support since I am not familiar with memblock code. 
> I could help in adaptation to the new API for ARM arch and
> core kernel code.
> 
> Let me know your thoughts.

Unfortunately, I'm currently a bit too occupied to work on it myself.
Any volunteers?

Thanks.

-- 
tejun
