Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3ICDWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 23:22:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:54340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3ICDWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 23:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1011,1367996400"; 
   d="scan'208";a="390168738"
Date: Tue, 3 Sep 2013 11:22:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903032235.GF17230@localhost>
References: <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <20130903003958.GA6855@localhost>
 <20130903013408.GA3437@leaf>
 <1378173165.1953.148.camel@joe-AO722>
 <20130903024640.GA11168@localhost>
 <20130903031645.GA5104@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903031645.GA5104@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 08:16:45PM -0700, Josh Triplett wrote:
> On Tue, Sep 03, 2013 at 10:46:40AM +0800, Fengguang Wu wrote:
> > On Mon, Sep 02, 2013 at 06:52:45PM -0700, Joe Perches wrote:
> > > On Mon, 2013-09-02 at 18:34 -0700, Josh Triplett wrote:
> > > > CONFIG_EXPERIMENTAL
> > > > CVS_KEYWORD
> > > 
> > > OK, but <shrug>
> [...]
> > Thanks for both of your suggestions! I'll add the commonly agreed ones:
> > 
> > +INVALID_UTF8
> > +LINUX_VERSION_CODE
> > +MISSING_EOF_NEWLINE
> > +HEXADECIMAL_BOOLEAN_TEST
> > +ALLOC_ARRAY_ARGS
> > +CONST_STRUCT
> > +CONSIDER_KSTRTO
> > 
> > And remove the duplicate one (good catch, Josh!)
> > 
> > -KREALLOC_ARG_REUSE
> 
> You missed CONFIG_EXPERIMENTAL and CVS_KEYWORD; see above.

OK, added, thanks!

Cheers,
Fengguang
