Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018Ab3FUIkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:40:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37943 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757862Ab3FUIkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:40:47 -0400
Date: Fri, 21 Jun 2013 09:40:19 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v2 0/2] ARM: Remove any correlation between IPC and
 BogoMips value
Message-ID: <20130621084018.GB6983@mudshark.cambridge.arm.com>
References: <1371746612-23950-1-git-send-email-will.deacon@arm.com>
 <alpine.LFD.2.03.1306201452330.18597@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1306201452330.18597@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 07:54:21PM +0100, Nicolas Pitre wrote:
> On Thu, 20 Jun 2013, Will Deacon wrote:
> 
> > Hi all,
> > 
> > This is version two of the patches I originally posted here:
> > 
> >   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166728.html
> > 
> > Comments received there largely confirmed that it's not possible to choose
> > an `obviously bogus' value for BogoMIPs, so instead I've bitten the bullet
> > and removed the line altogether.
> > 
> > In the meantime, I've only had one complaint this month about BogoMIPs
> > being wrong, so perhaps the initial posting served some purpose without
> > even being merged!
> > 
> > Comments welcome,
> 
> Enthusiastic ACK for both patches.

Thanks Nicolas!

Will
