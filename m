Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaBKVRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:17:36 -0500
Received: from one.firstfloor.org ([193.170.194.197]:56528 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBKVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:17:35 -0500
Date: Tue, 11 Feb 2014 22:17:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mtosatti@redhat.com, mgorman@suse.de,
        aarcange@redhat.com, andi@firstfloor.org, riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
Message-ID: <20140211211732.GS11821@two.firstfloor.org>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:27:44PM -0500, Luiz Capitulino wrote:
> HugeTLB command-line option hugepages= allows the user to specify how many
> huge pages should be allocated at boot. On NUMA systems, this argument
> automatically distributes huge pages allocation among nodes, which can
> be undesirable.
> 
> The hugepagesnid= option introduced by this commit allows the user
> to specify which NUMA nodes should be used to allocate boot-time HugeTLB
> pages. For example, hugepagesnid=0,2,2G will allocate two 2G huge pages
> from node 0 only. More details on patch 3/4 and patch 4/4.

The syntax seems very confusing. Can you make that more obvious?

-Andi
