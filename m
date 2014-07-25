Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbaGYHrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:47:20 -0400
Received: from 8bytes.org ([81.169.241.247]:59022 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002AbaGYHrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:47:18 -0400
Date: Fri, 25 Jul 2014 09:47:16 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, jroedel@suse.de,
        Jay.Cornwall@amd.com, Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] mmu_notifier: Allow to manage CPU external TLBs
Message-ID: <20140725074716.GK14017@8bytes.org>
References: <1406212541-25975-1-git-send-email-joro@8bytes.org>
 <20140724163303.df34065a3c3b26c0a4b3bab1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724163303.df34065a3c3b26c0a4b3bab1@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, Jul 24, 2014 at 04:33:03PM -0700, Andrew Morton wrote:
> On Thu, 24 Jul 2014 16:35:38 +0200 Joerg Roedel <joro@8bytes.org> wrote:
> > 
> > Any comments and review appreciated!
> 
> It looks pretty simple and harmless.
> 
> I assume the AMD IOMMUv2 driver actually uses this and it's all
> tested and good?  What is the status of that driver?

Yes, the AMD IOMMUv2 driver will use this once it is upstream, the
changes to be made there are pretty simple.

The driver itself will get its first user soon with the AMD KFD driver
currently under review.


	Joerg

