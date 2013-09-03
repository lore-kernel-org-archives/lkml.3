Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169Ab3ICAkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:40:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:32057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab3ICAkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:40:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1010,1367996400"; 
   d="scan'208";a="390124910"
Date: Tue, 3 Sep 2013 08:39:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903003958.GA6855@localhost>
References: <20130902195056.GB32628@leaf>
 <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378156296.1953.117.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 02:11:36PM -0700, Joe Perches wrote:
> On Mon, 2013-09-02 at 21:50 +0100, David Howells wrote:
> > Josh Triplett <josh@joshtriplett.org> wrote:
> > 
> > > > There are many checkpatch rules (like semicolons) that
> > > > are not in CodingStyle.
> > > 
> > > It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> > > not be enforcing style rules that aren't documented in CodingStyle.
> > 
> > Except that it becomes a mandate when someone runs it automatically against
> > every one of your patches and then sends you an email for each patch it finds
> > a checkpatch niggle against...
> 
> I think that any robot sending such checkpatch-only
> emails should be disabled.
> 
> I know of 2 email robots.
> 
> Fengguang Wu's very useful build robot
> sends out emails on build failures.
> I think that's great.

Thanks! Yes I'm now running checkpatch these days because some people
suggested to me that some of the checkpatch warnings do help catch
real bugs.

However I do try to avoid upsetting people with maybe-subjective
warnings. A checkpatch report will only be sent when a small fraction
of error types are detected. Comments are very welcome on how to
improve this list:

MEMSET
IN_ATOMIC
UAPI_INCLUDE
MALFORMED_INCLUDE       
SIZEOF_ADDRESS  
KREALLOC_ARG_REUSE      
EXECUTE_PERMISSIONS     
ERROR:BAD_SIGN_OFF      
LO_MACRO
HI_MACRO
CSYNC
SSYNC
HOTPLUG_SECTION
INDENTED_LABEL
INLINE_LOCATION
STORAGE_CLASS
USLEEP_RANGE
UNNECESSARY_CASTS
ALLOC_SIZEOF_STRUCT
KREALLOC_ARG_REUSE
USE_FUNC
LOCKDEP
EXPORTED_WORLD_WRITABLE
WHITESPACE_AFTER_LINE_CONTINUATION
MISSING_VMLINUX_SYMBOL
NEEDLESS_IF
PRINTF_L

Once the decision is made to send a checkpatch error/warning, the
report email will use the triggering error (the one that matters) as
the email subject, with the complete output of checkpatch.pl included
in email body.

Thanks,
Fengguang
