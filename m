Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaEMSpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:45:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57836 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753536AbaEMSpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:45:34 -0400
Date: Tue, 13 May 2014 19:45:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Sudeep Holla <Sudeep.Holla@arm.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Message-ID: <20140513184503.GF16388@arm.com>
References: <1398133596-29170-1-git-send-email-zhangwm@marvell.com>
 <20140422103642.GF7484@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3B59B@SC-VEXCH4.marvell.com>
 <20140423170821.GJ5649@arm.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE5507A3C1F1@SC-VEXCH4.marvell.com>
 <5360FB07.5030407@arm.com>
 <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 11:22:09AM +0100, Neil Zhang wrote:
> > > The device tree bindings for power domains is under discussion [1]
> > 
> > Thanks for the information.
> > But it currently for device only, core related stuff are not supported.
> > And is it really good to register power provider for core and let vfp / pmu etc
> > to get it?
> > 
> 
> What's your suggestion about it?
> Is it OK that I add it under the PMU node?

I don't really mind. I just want to avoid re-inventing the wheel in a
PMU-specific way and having to maintain that code forever because it ended
up in our DT description.

Will
