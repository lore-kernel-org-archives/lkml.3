Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3GHDaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 23:30:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:54141 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821Ab3GHDaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 23:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1016,1363158000"; 
   d="scan'208";a="361783922"
Date: Mon, 8 Jul 2013 11:30:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Jim Garlick <garlick@llnl.gov>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [v9fs:for-linus 7/7] ERROR: code indent should use tabs where
 possible
Message-ID: <20130708033004.GA20091@localhost>
References: <51d9c6c4.k6qhnvy45dNR8Ghq%fengguang.wu@intel.com>
 <20130708004233.GA8958@localhost>
 <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFkjPTk5EZ_d5BdTTHjgrwdtU1XfZ3go_7ZDCv4Q_oqnn95AHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sun, Jul 07, 2013 at 10:14:09PM -0500, Eric Van Hensbergen wrote:
> I've fixed this in my for-next branch, Linus rejected my pull on other
> grounds so this should let us fix up these style issues before the merge.
>  Thanks for catching this, I need to go back to running
> checkpatch.plbefore I pull into my tree.  Jim, please run
> checkpatch.pl before sending the patches in the future.  Its annoying and
> there are false positives, but we need to keep things consistent.

Thanks for fixing the style warnings! In long run I'd like to disable
the check types that tend to have false positives.  As for now, these
checks are disabled in my checkpatch robot:

PATCH_PREFIX
LONG_LINE
CAMELCASE
MISSING_SIGN_OFF
COMPLEX_MACRO
BRACES
SPACING
LONG_LINE
REDUNDANT_CODE
TRAILING_STATEMENTS
UNCOMMENTED_DEFINITION

Hopefully this can remind people to run scripts/checkpatch.pl earlier
when patches are still in their hands. :)

Thanks,
Fengguang

> On Sun, Jul 7, 2013 at 7:42 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.gitfor-linus
> > head:   ceb251d27e4f1001f3b3feca2e2c774f582e195d
> > commit: ceb251d27e4f1001f3b3feca2e2c774f582e195d [7/7] fs/9p: xattr: add
> > trusted and security namespaces
> >
> > scripts/checkpatch.pl0001-fs-9p-xattr-add-trusted-and-security-namespaces.patch
> >
> > ERROR: code indent should use tabs where possible
> > #84: FILE: fs/9p/xattr.c:176:
> > +        &v9fs_xattr_security_handler,$
> >
> > WARNING: please, no spaces at the start of a line
> > #84: FILE: fs/9p/xattr.c:176:
> > +        &v9fs_xattr_security_handler,$
> >
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology
> > Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel
> > Corporation
> >
