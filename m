Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3AWOCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 09:02:19 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45160 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755521Ab3AWOCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 09:02:15 -0500
Date: Wed, 23 Jan 2013 14:01:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents: decouple broadcast mechanism from drivers
Message-ID: <20130123140150.GA26811@mudshark.cambridge.arm.com>
References: <20130117172910.GA10070@e106331-lin.cambridge.arm.com>
 <20130118171545.GB15707@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130118171545.GB15707@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 05:15:46PM +0000, Mark Rutland wrote:
> Hello,
> 
> As has been pointed out elsewhere, in my haste to fix this up I made a
> typo in the first patch, preventing it from building.
> 
> Apologies for the confusion. I've created a new branch with a corrected
> and tested version. Please see the pull request below.
> 
> Thanks,
> Mark.
> 
> The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:
> 
>   Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)
> 
> are available in the git repository at:
> 
>   git://linux-arm.org/linux-mr.git for-tglx/timer-broadcast-v2

Can you pull this please Thomas? I need a stable branch so I can pull in the
ARM-specific changes, which are in turn required for the KVM patch series.

Cheers,

Will
