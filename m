Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab3DJFjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:39:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:56523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab3DJFje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:39:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,444,1363158000"; 
   d="scan'208";a="320114245"
Date: Wed, 10 Apr 2013 10:40:39 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] Add Intel Atom S1200 seris ioatdma support
Message-ID: <20130410051039.GK31193@intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
 <20130409072801.GB31193@intel.com>
 <CAA9_cmftcvYN_g0Sj12tMa4T8LxbPdk6wDxwkbTrgQPUUfc0FA@mail.gmail.com>
 <20130410050059.GI31193@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410050059.GI31193@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:30:59AM +0530, Vinod Koul wrote:
> On Tue, Apr 09, 2013 at 05:53:59PM -0700, Dan Williams wrote:
> > On Tue, Apr 9, 2013 at 12:28 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > > Are you okay with the series. Merge window is very close...
> > >
> > >
> > Hi Vinod, thanks for the ping.
> > 
> > Chatted with Dave patches 1-3 and 5-8, and 10 are reviewed/acked.  For
> > patch 4 and 9 we think we have a slightly cleaner way to organize the quirk
> > handling and an update will be coming.
> Dave,
> 
> I tried these, but they fail to apply on for-linus branch of my tree.
> Cna you pls rebase these 8 patches and resend.
Okay i forgot about the HSW ID patch. Applied that and then these worked till
last two, you would need to rebase those two only

Have applied rest
--
~Vinod
