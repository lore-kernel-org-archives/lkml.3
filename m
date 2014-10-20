Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaJTJUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:20:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57473 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbaJTJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:20:21 -0400
Date: Mon, 20 Oct 2014 10:20:05 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sudeep Holla <Sudeep.Holla@arm.com>
Cc: Neil Zhang <zhangwm@marvell.com>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devicetree@vger.kernel.org'" <devicetree@vger.kernel.org>,
        mathieu.poirier@linaro.org
Subject: Re: [PATCH v4] ARM: perf: save/restore pmu registers in pm notifier
Message-ID: <20141020092005.GD4370@arm.com>
References: <6106CAF835F351419ADA79E4836E6EC71B6A53C826@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED9A0875730@SC-VEXCH4.marvell.com>
 <20140513184503.GF16388@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A087573F@SC-VEXCH4.marvell.com>
 <537337F3.4080300@arm.com>
 <9034CBD80F070943B59700D7F8149ED9A0875776@SC-VEXCH4.marvell.com>
 <9034CBD80F070943B59700D7F8149ED90182308172@SC-VEXCH4.marvell.com>
 <20140703175706.GI17372@arm.com>
 <9034CBD80F070943B59700D7F8149ED9024EB81CD8@SC-VEXCH4.marvell.com>
 <5444D2E0.9070205@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5444D2E0.9070205@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:16:16AM +0100, Sudeep Holla wrote:
> On 20/10/14 09:46, Neil Zhang wrote:
> > Will, I prefer to check always-on field under PMU node to check
> > whether we need Save/restore them.
> >
> But how do you handle it for different idle states. e.g. if CPU is in
> retention, PMU's *might be* retained. Also I don't think PMUs will be
> placed in "always-on" power domain like timers. So using "always-on"
> sounds incorrect to me.

Adding Mathieu to CC, since I spoke to him at LPC about this and he was
talking about implementing proper PM domain descriptions for coresight
components.

Will
