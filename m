Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaIYPoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:44:18 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:37356 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaIYPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:44:16 -0400
Date: Thu, 25 Sep 2014 16:44:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-msm@vger.kernel.org'" <linux-arm-msm@vger.kernel.org>,
        "'Uwe =?iso-8859-1?Q?Kleine-K=F6nig'?=" 
	<u.kleine-koenig@pengutronix.de>,
        DL-WW-ContributionOfficers-Linux 
	<DL-WW-ContributionOfficers-Linux@sonymobile.com>
Subject: Re: [PATCH resend] arm:extend the reserved memory for initrd to be
 page aligned
Message-ID: <20140925154403.GL10390@e104818-lin.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D103D6DB49161F@CNBJMBX05.corpusers.net>
 <20140919095959.GA2295@e104818-lin.cambridge.arm.com>
 <20140925143142.GF5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925143142.GF5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 03:31:42PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 19, 2014 at 11:00:02AM +0100, Catalin Marinas wrote:
> > On Fri, Sep 19, 2014 at 08:09:47AM +0100, Wang, Yalin wrote:
> > > this patch extend the start and end address of initrd to be page aligned,
> > > so that we can free all memory including the un-page aligned head or tail
> > > page of initrd, if the start or end address of initrd are not page
> > > aligned, the page can't be freed by free_initrd_mem() function.
> > > 
> > > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > 
> > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > 
> > (as I said, if Russell doesn't have any objections please send the patch
> > to his patch system)
> 
> I now have an objection.  The patches in the emails were properly formatted.

They were so close ;)

I can see three patches but none of them exactly right:

8157/1 - wrong diff format
8159/1 - correct format, does not have my ack (you can take this one if
	 you want)
8162/1 - got my ack this time but with the wrong diff format again

Maybe a pull request is a better idea.

-- 
Catalin
