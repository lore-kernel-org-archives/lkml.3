Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139Ab3IDAtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:49:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:8913 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761533Ab3IDAtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:49:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1017,1367996400"; 
   d="scan'208";a="390693084"
Date: Wed, 4 Sep 2013 08:49:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Joe Perches <joe@perches.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Wang Shilong <wangshilong1991@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130904004903.GB8739@localhost>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <20130903003958.GA6855@localhost>
 <CAErSpo7jg1CU-tw3Rp60gJky2OE6g2QaQbEWFHE1Y_2GG2u37g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7jg1CU-tw3Rp60gJky2OE6g2QaQbEWFHE1Y_2GG2u37g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 12:09:31PM -0600, Bjorn Helgaas wrote:
> On Mon, Sep 2, 2013 at 6:39 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > Thanks! Yes I'm now running checkpatch these days because some people
> > suggested to me that some of the checkpatch warnings do help catch
> > real bugs.
> >
> > However I do try to avoid upsetting people with maybe-subjective
> > warnings. A checkpatch report will only be sent when a small fraction
> > of error types are detected. Comments are very welcome on how to
> > improve this list:
> 
> How hard would it be to make this configurable per-git tree?

It'd be trivial to do.

> I think the robot is quite useful and I don't push branches very
> often, so I'd probably be OK with just getting all the checkpatch
> warnings along with the build warnings and filtering the noise
> myself.  But I know other people have different styles and opinions.

Would you tell me the git tree/branches that would like to receive all
checkpatch warnings? It'll should be useful for our internal kernel
team, too.

Thanks,
Fengguang

> > MEMSET
> > IN_ATOMIC
> > UAPI_INCLUDE
> > MALFORMED_INCLUDE
> > SIZEOF_ADDRESS
> > KREALLOC_ARG_REUSE
> > EXECUTE_PERMISSIONS
> > ERROR:BAD_SIGN_OFF
> > LO_MACRO
> > HI_MACRO
> > CSYNC
> > SSYNC
> > HOTPLUG_SECTION
> > INDENTED_LABEL
> > INLINE_LOCATION
> > STORAGE_CLASS
> > USLEEP_RANGE
> > UNNECESSARY_CASTS
> > ALLOC_SIZEOF_STRUCT
> > KREALLOC_ARG_REUSE
> > USE_FUNC
> > LOCKDEP
> > EXPORTED_WORLD_WRITABLE
> > WHITESPACE_AFTER_LINE_CONTINUATION
> > MISSING_VMLINUX_SYMBOL
> > NEEDLESS_IF
> > PRINTF_L
> >
> > Once the decision is made to send a checkpatch error/warning, the
> > report email will use the triggering error (the one that matters) as
> > the email subject, with the complete output of checkpatch.pl included
> > in email body.
> >
> > Thanks,
> > Fengguang
> > _______________________________________________
> > Ksummit-2013-discuss mailing list
> > Ksummit-2013-discuss@lists.linuxfoundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss
