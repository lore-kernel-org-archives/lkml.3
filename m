Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3DJF34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:29:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:3604 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3DJF3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="316995475"
Date: Wed, 10 Apr 2013 10:30:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
Message-ID: <20130410050059.GI31193@intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
 <20130409072801.GB31193@intel.com>
 <CAA9_cmftcvYN_g0Sj12tMa4T8LxbPdk6wDxwkbTrgQPUUfc0FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9_cmftcvYN_g0Sj12tMa4T8LxbPdk6wDxwkbTrgQPUUfc0FA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:53:59PM -0700, Dan Williams wrote:
> On Tue, Apr 9, 2013 at 12:28 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > Are you okay with the series. Merge window is very close...
> >
> >
> Hi Vinod, thanks for the ping.
> 
> Chatted with Dave patches 1-3 and 5-8, and 10 are reviewed/acked.  For
> patch 4 and 9 we think we have a slightly cleaner way to organize the quirk
> handling and an update will be coming.
Dave,

I tried these, but they fail to apply on for-linus branch of my tree.
Cna you pls rebase these 8 patches and resend.

--
~Vinod
