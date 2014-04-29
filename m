Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaD2Xif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 19:38:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:36375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbaD2Xid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 19:38:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,954,1389772800"; 
   d="scan'208";a="425642639"
Date: Tue, 29 Apr 2014 16:38:28 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "David E. Box" <david.e.box@linux.intel.com>, linux-pm@vger.kernel.org,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        hpa@linux.intel.com, alan@linux.intel.com, durgadoss.r@intel.com,
        kristen.c.accardi@intel.com
Subject: Re: [PATCH v2 0/4] RAPL driver updates
Message-ID: <20140429163828.040c0f97@ultegra>
In-Reply-To: <2848366.d6jLR9v0Ov@vostro.rjw.lan>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
	<2848366.d6jLR9v0Ov@vostro.rjw.lan>
Organization: OTC
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2014 01:02:36 +0200
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Tuesday, April 29, 2014 03:33:05 PM David E. Box wrote:
> > From: "David E. Box" <david.e.box@linux.intel.com>
> > 
> > v2: iosf: Remove Kconfig exposure. Make mailbox driver a module.
> > 
> > David E. Box (1):
> >   x86/iosf: Make IOSF driver modular and usable by more drivers
> > 
> > Jacob Pan (3):
> >   powercap/rapl: further relax energy counter checks
> >   powercap/rapl: add new cpu ids
> >   powercap/rapl: change floor frequency for vallewview
> 
> I'm fine with [1-2/4].
> 
> [3/4] has to go via the x86 tree and [4/4] probably too, because it
> depends on [3/4].
> 
OK. I will update [4/4] to be submitted to x86 tree with [3/4].
> So would you like me to queue up [1-2/4] without the remaining two
> for 3.16?
> 
Sure. thanks.

> 

[Jacob Pan]
