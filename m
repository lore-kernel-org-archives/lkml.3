Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaILTTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:19:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaILTTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:19:39 -0400
Date: Fri, 12 Sep 2014 12:19:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <jroedel@suse.de>
Cc: Joerg Roedel <joro@8bytes.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <jweiner@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, Jay.Cornwall@amd.com,
        Oded.Gabbay@amd.com, John.Bridgman@amd.com,
        Suravee.Suthikulpanit@amd.com, ben.sander@amd.com,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 0/3 v3] mmu_notifier: Allow to manage CPU external TLBs
Message-Id: <20140912121937.ebb3010d52abd4196e9341de@linux-foundation.org>
In-Reply-To: <20140912184739.GF2519@suse.de>
References: <1410277434-3087-1-git-send-email-joro@8bytes.org>
	<20140910150125.31a7495c7d0fe814b85fd514@linux-foundation.org>
	<20140912184739.GF2519@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014 20:47:39 +0200 Joerg Roedel <jroedel@suse.de> wrote:

> thanks for your review, I tried to answer your questions below.

You'd be amazed how helpful that was ;)

> Fair enough, I hope I clarified a few things with my explanations
> above. I will also update the description of the patch-set when I
> re-send.

Sounds good, thanks.


How does HMM play into all of this?  Would HMM make this patchset
obsolete, or could HMM be evolved to do so?  
