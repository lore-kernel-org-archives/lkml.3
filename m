Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaIMJZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 05:25:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:52377 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaIMJZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 05:25:31 -0400
Date: Sat, 13 Sep 2014 11:25:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] Intel MPX support
In-Reply-To: <54136459.1070700@intel.com>
Message-ID: <alpine.DEB.2.10.1409131121570.23397@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <54124379.5090502@intel.com> <alpine.DEB.2.10.1409121543090.4178@nanos> <54136459.1070700@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Dave Hansen wrote:

> On 09/12/2014 12:21 PM, Thomas Gleixner wrote:
> > Yes, the most important question is WHY must the kernel handle the
> > bound table memory allocation in the first place. The "documentation"
> > patch completely fails to tell that.
> 
> This will become the description of "patch 04/10".  Feel free to wait

Thanks for writing this up! That helps a lot.

> until we repost these to read it, but I'm posting it here because it's
> going to be a couple of days before we actually get a new set of patches
> out.
> 
> Any suggestions for how much of this is appropriate for Documentation/
> would be much appreciated.  I don't have a good feel for it.

I think all of it. The kernels problem is definitely not that it
drains in documentation :)
 
> Having ruled out all of the userspace-only approaches for managing
> bounds tables that we could think of, we create them on demand
> in the kernel.

So what the documentation wants on top of this is the rule set which
describes the expected behaviour of sane applications and perhaps the
potential consequences for insane ones. Not that people care about
that much, but at least we can point them to documentation if they
come up with their weird ass "bug" reports :)

Thanks,

	tglx
