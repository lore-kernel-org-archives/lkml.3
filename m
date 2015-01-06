Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbbAFTkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:40:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:26949 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512AbbAFTj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:39:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,709,1413270000"; 
   d="scan'208";a="665341102"
Date: Tue, 6 Jan 2015 11:36:10 -0800
From: "David E. Box" <david.e.box@linux.intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [Devel] [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Message-ID: <20150106193610.GA7141@pathfinder>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
 <1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
 <1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
 <87oaqdy13n.fsf@rasmusvillemoes.dk>
 <1AE640813FDE7649BE1B193DEA596E88026AB06A@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026AB06A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:30:05AM +0000, Zheng, Lv wrote:
> Hi,
> 
> > From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > Sent: Monday, January 05, 2015 6:27 PM
> > 
> > On Mon, Jan 05 2015, "Zheng, Lv" <lv.zheng@intel.com> wrote:
> > 
> > > Hi,
> > >
> > >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> > >> Sent: Friday, December 12, 2014 6:51 PM
> > >> To: Zheng, Lv
> > >> Cc: Rasmus Villemoes; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> > >> Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
> > >>
> > >> The macro __DATE__ and friends is not allowed in the kernel. Also,
> > >> including the build time in output doesn't seem to provide any value.
> > >>
> > >
> > > Could you confirm that it is not useful even for the user tools?
> > > Please perform the following commands in the kernel source tree
> > > 1. stay in tools folder
> > > 2. type "make acpi"
> > > 3. type "./power/acpi/acpidump -v"
> > >
> > 
> > Yeah, it's part of the output, but for what reason? What can userspace
> > possibly use that information for?
> 
> I also want to know.

I don't see a reason for userspace to know the build date.

> 
> > I can see some utility in printing a
> > version number, since that may tell something about the features
> > present or absent. The compilation date, on the other hand, seems
> > completely useless. Different distros may ship different versions which
> > happened to be compiled on the same day, or older versions compiled later.
> 
> If the deletion was done for this reason, IMO, it's acceptable.
> So let's wait to see others' feedback.
> 

I'm okay with removing it (the build date) in Linux and ACPICA as well. However
the version, which is essentially the release date, is important for the exact
reasons already stated.

Dave
