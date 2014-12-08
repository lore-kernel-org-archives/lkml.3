Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaLHKKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:10:31 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45966 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbaLHKKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:10:30 -0500
Date: Mon, 8 Dec 2014 10:10:26 +0000
From: Will Deacon <will.deacon@arm.com>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>, Michael Matz <matz@suse.de>
Subject: Re: [PATCH] arm64: Enable CONFIG_COMPAT also for 64k page size
Message-ID: <20141208101026.GD27367@arm.com>
References: <1417707993-82290-1-git-send-email-agraf@suse.de>
 <20141204182049.GB7749@arm.com>
 <54833BAF.1030405@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54833BAF.1030405@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2014 at 05:23:59PM +0000, Alexander Graf wrote:
> On 04.12.14 19:20, Will Deacon wrote:
> > On Thu, Dec 04, 2014 at 03:46:33PM +0000, Alexander Graf wrote:
> >> With binutils 2.25 the default alignment for 32bit arm sections changed to
> >> have everything 64k aligned. Armv7 binaries built with this binutils version
> >> run successfully on an arm64 system.
> >>
> >> Since effectively there is now the chance to run armv7 code on arm64 even
> >> with 64k page size, it doesn't make sense to block people from enabling
> >> CONFIG_COMPAT on those configurations.
> > 
> > Is there a distro available that is built with a recent enough binutils for
> > this? I'd really like to run our regression tests to check that page-size
> > assumptions don't exist for things like shm.
> 
> So how much of a distro do you need? I could probably assemble a simple
> very minimalistic rootfs with only bash if that helps.

I'd like to run LTP, so I'd probably need slightly more than that but I
certainly don't need the whole world.

Will
