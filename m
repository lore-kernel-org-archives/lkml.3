Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaDOBwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:52:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:41003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaDOBwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:52:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,861,1389772800"; 
   d="scan'208";a="492932243"
Date: Mon, 14 Apr 2014 18:52:33 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT] kbuild/lto changes for 3.15-rc1
Message-ID: <20140415015233.GE32556@tassilo.jf.intel.com>
References: <20140407201919.GA15838@sepie.suse.cz>
 <CA+55aFy8hWqBpF1TXOPvA2rRaZp=H2LTO3wd3AERspmcGZhAeQ@mail.gmail.com>
 <20140408204906.GA3616@cloud>
 <CA+55aFzhyvZRPjXy7PkUxQO_AMqLSTehh-GNRP+Dx3yKnv-eCA@mail.gmail.com>
 <20140409013557.GA32556@tassilo.jf.intel.com>
 <20140409060133.GA6766@gmail.com>
 <20140409081709.GA283@x4>
 <20140414103205.GA2846@gmail.com>
 <20140415010003.GA2765@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415010003.GA2765@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > and it slows down 
> > kernel development'.
> 
> No, it doesn't slow down development builds; it makes kernel builds
> slower if and only if LTO is turned on, which most kernel developers
> won't need to do.  On the other hand, distro and embedded kernels can do
> so for final builds, and developers pushing to minimize the kernel can
> turn it on for their own work as needed.

Yes and the patch even takes special care that you will not enable
it by mistake.

-Andi
