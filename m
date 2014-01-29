Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaA2Bv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 20:51:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35053 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbaA2Bv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 20:51:26 -0500
Date: Tue, 28 Jan 2014 20:50:48 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
Message-ID: <20140129015048.GA14629@konrad-lan.dumpdata.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
 <52E82A40.3040104@intel.com>
 <CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 02:47:57PM -0800, Yinghai Lu wrote:
> On Tue, Jan 28, 2014 at 2:08 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> > On 01/28/2014 02:04 PM, Yinghai Lu wrote:
> >> In original bootmem wrapper for memblock, we have limit checking.
> >>
> >> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
> >>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > Do you have a git tree or cumulative set of patches that you'd like us
> > to all test?  I'm happy to boot it on my system, I just want to make
> > sure I've got the same set that you're testing.
> 
> This one should only affect on arm and x86 the 32 bit kernel with more
> then 4G RAM.

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

It fixes the issue I saw with Xen and 32-bit dom0 blowing up.

> 
> thanks
> 
> Yinghai
