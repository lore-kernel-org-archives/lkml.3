Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbaBDJQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:16:03 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58113 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaBDJP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:15:57 -0500
Date: Tue, 4 Feb 2014 10:15:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@redhat.com, "Ira W. Snyder" <iws@ovro.caltech.edu>,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 0/2] tools: lockdep: build fixes
Message-ID: <20140204091554.GC19156@gmail.com>
References: <1391204132-14071-1-git-send-email-iws@ovro.caltech.edu>
 <52F05B7A.9040209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F05B7A.9040209@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sasha Levin <sasha.levin@oracle.com> wrote:

> On 01/31/2014 04:35 PM, Ira W. Snyder wrote:
> >From: "Ira W. Snyder" <iws@ovro.caltech.edu>
> >
> >Included are some fixes to the tools/lib/lockdep source tree to fix some
> >build issues.
> >
> >Ira W. Snyder (2):
> >   tools: lockdep: fix include of asm/hash.h
> >   tools: lockdep: add include directory to allow tests to compile
> >
> >  tools/lib/lockdep/Makefile            | 2 +-
> >  tools/lib/lockdep/uinclude/asm/hash.h | 6 ++++++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h
> >
> 
> 	Acked-by: Sasha Levin <sasha.levin@oracle.com>
> 
> Ingo, How would you like the liblockdep things to work? Would you be 
> picking them yourself directly to the locking tree or should I be 
> sending a pull request?

Let's try a pull request? Initially it might need several iterations 
(rebasing) as the requirements for pull requests are always much more 
stringent, as I cannot fix up small details.

Thanks,

	Ingo
