Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbaF3TLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:11:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:59165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbaF3TLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:11:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,576,1400050800"; 
   d="scan'208";a="555417711"
Subject: Re: [PATCH char-misc-next v2 0/8] Enable dma driver for MIC X100
 Coprocessors
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: sudeep.dutt@intel.com, Dan Williams <dan.j.williams@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
In-Reply-To: <20140630162718.GE24179@kroah.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
	 <1402934289.16234.6.camel@rbtaylor-desk1.amr.corp.intel.com>
	 <1404142433.27474.6.camel@rbtaylor-desk1.amr.corp.intel.com>
	 <20140630162718.GE24179@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Jun 2014 12:04:29 -0700
Message-ID: <1404155069.11388.11.camel@rbtaylor-desk1.amr.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 09:27 -0700, Greg Kroah-Hartman wrote:
> On Mon, Jun 30, 2014 at 08:33:53AM -0700, Sudeep Dutt wrote:
> > On Mon, 2014-06-16 at 08:58 -0700, Sudeep Dutt wrote:
> > > On Thu, 2014-05-29 at 14:23 -0700, Sudeep Dutt wrote:
> > > > ChangeLog:
> > > > =========
> > > > v1 => v2:
> > > > a) MIC bus driver cleanups and device release callback fix in patch 2,
> > > >    as per feedback from Greg Kroah-Hartman.
> > > > 
> > > > v1: Initial post @ https://lkml.org/lkml/2014/5/27/819
> > > > 
> > > 
> > > Hi Greg/Dan,
> > > 
> > > We have addressed the feedback received so far. Please take a look at
> > > this patch series.
> > > 
> > 
> > Another gentle reminder to take a look at this patch series. Greg/Dan,
> > please let us know what we can do to speed things up here.
> 
> Wait for me to get back from vacation next week :)
> 

Sounds good. I do see a minor conflict in patch 3 with v3.16-rc1 which
can be fixed up with a trivial Makefile change for adding the driver to
the end of the file. Please let me know if you want me to resend the
patch series with that fixed up.

Thanks,
Sudeep Dutt

