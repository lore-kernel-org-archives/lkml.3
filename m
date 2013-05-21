Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab3EUNwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:52:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:51068
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673Ab3EUNwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:52:40 -0400
Date: Tue, 21 May 2013 15:52:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
        iommu@lists.linux-foundation.org, joro@8bytes.org
Subject: Re: [PATCH 0/2 V3] perf/x86/amd: IOMMU Performance Counter Support
Message-ID: <20130521135231.GK26912@twins.programming.kicks-ass.net>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
 <519A4429.30405@amd.com>
 <20130521091157.GD26912@twins.programming.kicks-ass.net>
 <519B76CB.1000208@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519B76CB.1000208@amd.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 08:29:47AM -0500, Suravee Suthikulanit wrote:
> On 5/21/2013 4:11 AM, Peter Zijlstra wrote:
> >On Mon, May 20, 2013 at 10:41:29AM -0500, Suravee Suthikulanit wrote:
> >>Peter,
> >>
> >>Please let me know if you have any questions/concerns regarding the PMU
> >>implementation.
> >Looks good, how would you like to go about merging this? Should I push
> >it through Ingo's tree or do you prefer it goes through some IOMMU tree?
> >
> Thank you, Peter.  Since this is mostly PERF-related feature, I think it
> would be appropriate to push this through Ingo's tree.

OK, I'll take them and will push them to Ingo. 

Thanks!
