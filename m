Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3JMSmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:42:17 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:62325 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab3JMSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:42:16 -0400
Date: Sun, 13 Oct 2013 14:42:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, grygorii.strashko@ti.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 06/23] mm/memblock: Add memblock early memory allocation
 apis
Message-ID: <20131013184212.GA18075@htj.dyndns.org>
References: <1381615146-20342-1-git-send-email-santosh.shilimkar@ti.com>
 <1381615146-20342-7-git-send-email-santosh.shilimkar@ti.com>
 <20131013175648.GC5253@mtj.dyndns.org>
 <20131013180058.GG25034@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013180058.GG25034@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 07:00:59PM +0100, Russell King - ARM Linux wrote:
> On Sun, Oct 13, 2013 at 01:56:48PM -0400, Tejun Heo wrote:
> > Hello,
> > 
> > On Sat, Oct 12, 2013 at 05:58:49PM -0400, Santosh Shilimkar wrote:
> > > Introduce memblock early memory allocation APIs which allow to support
> > > LPAE extension on 32 bits archs. More over, this is the next step
> > 
> > LPAE isn't something people outside arm circle would understand.
> > Let's stick to highmem.
> 
> LPAE != highmem.  Two totally different things, unless you believe
> system memory always starts at physical address zero, which is very
> far from the case on the majority of ARM platforms.
> 
> So replacing LPAE with "highmem" is pure misrepresentation and is
> inaccurate.  PAE might be a better term, and is also the x86 term
> for this.

Ah, right, forgot about the base address.  Let's please spell out the
requirements then.  Briefly explaining both aspects (non-zero base
addr & highmem) and why the existing bootmem based interfaced can't
serve them would be helpful to later readers.

Thanks.

-- 
tejun
