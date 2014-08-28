Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaH1Qug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:50:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:17958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaH1Quf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:50:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,418,1406617200"; 
   d="scan'208";a="591230783"
Date: Thu, 28 Aug 2014 12:50:12 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 00/21] Support ext4 on NV-DIMMs
Message-ID: <20140828165012.GK3285@linux.intel.com>
References: <cover.1409110741.git.matthew.r.wilcox@intel.com>
 <20140827130613.c8f6790093d279a447196f17@linux-foundation.org>
 <20140827211250.GH3285@linux.intel.com>
 <20140827144622.ed81195a1d94799bb57a3207@linux-foundation.org>
 <53FE8633.10305@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FE8633.10305@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 06:30:27PM -0700, Andy Lutomirski wrote:
> 4) No page faults ever once a page is writable (I hope -- I'm not sure
> whether this series actually achieves that goal).

I can't think of a circumstance in which you'd end up taking a page fault
after a writable mapping is established.

The next part to this series (that I'm working on now) is PMD support.
