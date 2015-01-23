Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbbAWPaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:30:10 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41935 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbbAWPaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:30:04 -0500
Date: Fri, 23 Jan 2015 15:29:56 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Min-Hua Chen <orca.chen@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: add ioremap physical address information
Message-ID: <20150123152956.GA9557@e104818-lin.cambridge.arm.com>
References: <CAHkaATSM=V+BNZvAXC+VG6NDjOK9m0ZP3Q=SUaoxtgDw4SKZog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkaATSM=V+BNZvAXC+VG6NDjOK9m0ZP3Q=SUaoxtgDw4SKZog@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 04:52:10PM +0000, Min-Hua Chen wrote:
> In /proc/vmallocinfo, it's good to show the physical address
> of each ioremap in vmallocinfo. Add physical address information
> in arm64 ioremap.
> 
> 0xffffc900047f2000-0xffffc900047f4000    8192 _nv013519rm+0x57/0xa0
> [nvidia] phys=f8100000 ioremap
> 0xffffc900047f4000-0xffffc900047f6000    8192 _nv013519rm+0x57/0xa0
> [nvidia] phys=f8008000 ioremap
> 0xffffc90004800000-0xffffc90004821000  135168 e1000_probe+0x22c/0xb95
> [e1000e] phys=f4300000 ioremap
> 0xffffc900049c0000-0xffffc900049e1000  135168 _nv013521rm+0x4d/0xd0
> [nvidia] phys=e0140000 ioremap
> 
> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>

Applied. Thanks.

-- 
Catalin
