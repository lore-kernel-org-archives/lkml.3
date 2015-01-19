Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbbASOkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:40:33 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38083 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbbASOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:40:32 -0500
Date: Mon, 19 Jan 2015 14:40:28 +0000
From: Will Deacon <will.deacon@arm.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Wagantall <mattw@codeaurora.org>, Robert Elliott <elliott@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] iopoll: Introduce memory-mapped IO polling macros
Message-ID: <20150119144028.GA2373@arm.com>
References: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org>
 <20141216094527.GC6580@arm.com>
 <vnkwtwztp2rm.fsf@mitchelh-linux.qualcomm.com>
 <20150115102511.GB23475@arm.com>
 <20150119124348.GA2806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119124348.GA2806@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:43:48PM +0000, Joerg Roedel wrote:
> On Thu, Jan 15, 2015 at 10:25:11AM +0000, Will Deacon wrote:
> > If you get an Ack from any of Arnd/Joerg/akpm then I'm happy to take it via
> > the arm-smmu pull (along with the patch making use of it).
> > 
> > Joerg, would you be ok with that?
> 
> I am ok with that, but like to have another Ack for it.

That's fair enough.

Arnd, could you take another look at this patch please? You had some
comments in the past.

Will
