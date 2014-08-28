Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbaH1AsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 20:48:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:34612 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaH1AsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 20:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="582647559"
Date: Thu, 28 Aug 2014 08:47:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Guy Martin <guy.martin@samsung.com>, Julia Lawall <julia.lawall@lip6.fr>,
        kbuild@01.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linuxtv-media:devel 497/499]
 drivers/media/platform/s5p-mfc/s5p_mfc.c:454:2-5: WARNING: Use BUG_ON
Message-ID: <20140828004751.GA31482@localhost>
References: <53fe0d6b.ILcqU401zWlsffkn%fengguang.wu@intel.com>
 <alpine.DEB.2.10.1408271905180.7069@hadrien>
 <20140827143137.2bc29eed.m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827143137.2bc29eed.m.chehab@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Wed, Aug 27, 2014 at 02:31:37PM -0300, Mauro Carvalho Chehab wrote:
> Hi Fengguang,
> 
> Not sure why, but I didn't receive this e-mail (or other emails in this
> thread).

It's a manual check process rather than an email problem.  The TO/CC
you see lie in the email body. The original email is sent to the
kbuild list for manual checking. We do such check for all low
confident static check warnings. Julia and Dan are actively looking at
these reports and will forward the ones that worth more attention to
the relevant people.

Thanks,
Fengguang

> Em Wed, 27 Aug 2014 19:07:45 +0200 (CEST)
> Julia Lawall <julia.lawall@lip6.fr> escreveu:
> 
> > The bug_on one doesn't look like a good idea, but the returnvar one would
> > make the code a little simpler.
> > 
> > julia
> > 
> > On Thu, 28 Aug 2014, kbuild test robot wrote:
> > 
> > > TO: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > > CC: linux-media@vger.kernel.org
> > >
> > > Hi Mauro,
> > >
> > > First bad commit (maybe != root cause):
> > >
> > > tree:   git://linuxtv.org/media_tree.git devel
> > > head:   38a0731165250a0a77eff7b90ea3156d44cc7d66
> > > commit: 7155043c2d027c9c848c3d09badb5af2894ed652 [497/499] [media] enable COMPILE_TEST for media drivers
> > > :::::: branch date: 19 hours ago
> > > :::::: commit date: 19 hours ago
> > >
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:454:2-5: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:333:3-6: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:406:2-5: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:548:3-6: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:556:3-6: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:509:2-5: WARNING: Use BUG_ON
> > > >> drivers/media/platform/s5p-mfc/s5p_mfc.c:634:4-7: WARNING: Use BUG_ON
> > > --
> > > >> drivers/media/platform/davinci/vpfe_capture.c:946:5-8: Unneeded variable: "ret". Return "0" on line 951
> > >
> > > Please consider folding the attached diff :-)
> > >
> > > ---
> > > 0-DAY kernel build testing backend              Open Source Technology Center
> > > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
> > >
