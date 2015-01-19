Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbbASMny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:43:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbbASMnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:43:52 -0500
Date: Mon, 19 Jan 2015 13:43:48 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Matt Wagantall <mattw@codeaurora.org>, Robert Elliott <elliott@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10] iopoll: Introduce memory-mapped IO polling macros
Message-ID: <20150119124348.GA2806@suse.de>
References: <1418687243-16395-1-git-send-email-mitchelh@codeaurora.org>
 <20141216094527.GC6580@arm.com>
 <vnkwtwztp2rm.fsf@mitchelh-linux.qualcomm.com>
 <20150115102511.GB23475@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115102511.GB23475@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 10:25:11AM +0000, Will Deacon wrote:
> If you get an Ack from any of Arnd/Joerg/akpm then I'm happy to take it via
> the arm-smmu pull (along with the patch making use of it).
> 
> Joerg, would you be ok with that?

I am ok with that, but like to have another Ack for it.


	Joerg

