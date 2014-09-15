Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaIONPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:15:20 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:32931 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbaIONPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:15:18 -0400
Date: Mon, 15 Sep 2014 14:15:06 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC Resend] arm:extend __init_end to a page align address
Message-ID: <20140915131505.GB5415@arm.com>
References: <35FD53F367049845BC99AC72306C23D103CDBFBFB028@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103D6DB4915FB@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103D6DB491607@CNBJMBX05.corpusers.net>
 <20140915105525.GC12361@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915105525.GC12361@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 11:55:25AM +0100, Russell King - ARM Linux wrote:
> On Mon, Sep 15, 2014 at 06:26:43PM +0800, Wang, Yalin wrote:
> > this patch change the __init_end address to a page align address, so that free_initmem()
> > can free the whole .init section, because if the end address is not page aligned,
> > it will round down to a page align address, then the tail unligned page will not be freed.
> 
> Please wrap commit messages at or before column 72 - this makes "git log"
> much easier to read once the change has been committed.
> 
> I have no objection to the arch/arm part of this patch.  However, since
> different people deal with arch/arm and arch/arm64, this patch needs to
> be split.

I don't mind how it goes in. If Russell is ok to take the whole patch:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
