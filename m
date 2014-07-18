Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbaGRPu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:50:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:50102 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751376AbaGRPuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:50:25 -0400
Date: Fri, 18 Jul 2014 16:50:03 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Will Deacon <Will.Deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] arm64: Use include/asm-generic/io.h
Message-ID: <20140718155002.GE4608@arm.com>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <1405508484-18303-3-git-send-email-thierry.reding@gmail.com>
 <20140717120441.GI18203@arm.com>
 <20140717122649.GA1006@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717122649.GA1006@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:26:51PM +0100, Thierry Reding wrote:
> On Thu, Jul 17, 2014 at 01:04:41PM +0100, Catalin Marinas wrote:
> > On Wed, Jul 16, 2014 at 12:01:24PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > > 
> > > Include the generic I/O header file so that duplicate implementations
> > > can be removed. This will also help to establish consistency across more
> > > architectures regarding which accessors they support.
> > > 
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > > Changes in v3:
> > > - add io{read,write}{16,32}be() to match what 32-bit ARM does
> > 
> > It looks fine. Thanks.
> 
> Great. Russell hasn't commented on this yet, anyone know how to get his
> attention?

Given he dependency on the first patch, they should either go in
together or first patch in 3.17 and the rest later (but I would prefer
that they all go in at the same time).

I don't mind how they are merged (the arm32 tree, arm-soc or arm64). If
Russell doesn't have an opinion, I can take the 1st and 3rd patches via
the arm64 tree.

-- 
Catalin
