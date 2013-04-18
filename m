Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967611Ab3DRXww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:52:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:65161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967289Ab3DRXwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:52:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,504,1363158000"; 
   d="scan'208";a="320599348"
Date: Thu, 18 Apr 2013 16:52:45 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
Message-ID: <20130418235245.GA3565@xanatos>
References: <20130417182328.GA7690@xanatos>
 <1366242580.18069.116@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366242580.18069.116@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 06:49:40PM -0500, Rob Landley wrote:
> On 04/17/2013 01:23:28 PM, Sarah Sharp wrote:
> >On Tue, Apr 16, 2013 at 09:15:06PM -0500, Rob Landley wrote:
> >> On 04/15/2013 12:33:34 PM, Sarah Sharp wrote:
> >> >Outline how often it's polite to ping kernel maintainers about
> >> >bugs, and
> >> >suggest that kernel maintainers should respond to bugs in 1 to 5
> >> >business days.
> >>
> >> Is there anything in here about the four-level nature of modern
> >> maintainership?
> >>
> >> Patches go from the developer, to the maintainer, to one of Linus's
> >> lieutenants, to Linus himself. If you submit a patch to a maintainer
> >> they owe you a response. The lieutenant (subsystem maintainer) owes
> >> that maintainer a response, and Linus (the project's architect) owes
> >> the lieutenant a response.
> >
> >Do we want to go into this much detail in a document meant for
> >frustrated bug reporters?  Or perhaps we should create a separate
> >document about the kernel maintainer hierarchy and reference it here?
> 
> My point was that you have to contact the right person to
> semi-reliably get a response, but you're right. That's more about
> getting patches in than getting problems reproduced and diagnosed.

No worries!  I think it's really useful for patch submitters to get
their work to the right maintainers as well.  That description just
doesn't belong here. :)

> >This file is about bug reporting, not submitting patches.
> ...
> >TLDR version: Yes, it would be nice if bug reporters could go up the
> >hierarchy, but they don't have an easy way to know which subsystem
> >maintainers to contact.  Perhaps a new line in MAINTAINERS for the
> >subsystem maintainer would be helpful?
> 
> It seemed related at the time (general interacting with the
> kernel developers), but I guess not.

Ok.  Do you think the new line in MAINTAINERS would be useful as a
separate patch?  Possibly if it came from the subsystem maintainers
themselves?

> Eh, this has gone undocumented for a full decade and nobody but me's
> cared.

I think it's less "nobody but me's cared" and more "no one with
knowledge of the community is willing to write basic documentation that
is needed".  People care, just not the ones with enough expertise to
write docs.

I do care about good documentation, so I suspect you'll be getting
more patches from me in the future. :)

Any other feedback on this patchset?  If not, are you going to send
it to Linus for 3.10 or should I?

Sarah Sharp
