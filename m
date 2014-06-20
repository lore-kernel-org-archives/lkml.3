Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbaFTIkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:40:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42722 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934822AbaFTIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:40:15 -0400
Date: Fri, 20 Jun 2014 09:39:47 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: add the ability to hook the fault code
Message-ID: <20140620083946.GF25104@arm.com>
References: <1403175296-25181-1-git-send-email-zhangwm@marvell.com>
 <20140620082556.GD25104@arm.com>
 <9034CBD80F070943B59700D7F8149ED90182148D02@SC-VEXCH4.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9034CBD80F070943B59700D7F8149ED90182148D02@SC-VEXCH4.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 09:33:59AM +0100, Neil Zhang wrote:
> 
> > -----Original Message-----
> > From: Will Deacon [mailto:will.deacon@arm.com]
> > Sent: 2014年6月20日 16:26
> > To: Neil Zhang
> > Cc: Catalin Marinas; linux-arm-kernel@lists.infradead.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] arm64: add the ability to hook the fault code
> > 
> > On Thu, Jun 19, 2014 at 11:54:56AM +0100, Neil Zhang wrote:
> > > Add the ability to hook the fault code for future use.
> > 
> > Do you have a user for this in the kernel tree? I'd rather add the hook with
> > the first user, if it doesn't exist already.
> > 
> 
> Marvell Soc has a feature to use the external abort.
> I didn't submit it since it's a private feature.

In which case, let's wait until we have a user of this in the mainline tree.

Will
