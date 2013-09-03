Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268Ab3ICCVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 22:21:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55512 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759207Ab3ICCV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 22:21:29 -0400
Message-ID: <1378174887.1953.152.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Date: Mon, 02 Sep 2013 19:21:27 -0700
In-Reply-To: <20130903021207.GA4045@leaf>
References: <1378138205.1953.66.camel@joe-AO722>
	 <20130902181510.GA29787@leaf> <20130902181856.GB29787@leaf>
	 <20130902153945.6d7e510c@samsung.com> <1378148367.1953.98.camel@joe-AO722>
	 <13834.1378155023@warthog.procyon.org.uk>
	 <1378156296.1953.117.camel@joe-AO722> <20130903003958.GA6855@localhost>
	 <20130903013408.GA3437@leaf> <1378173165.1953.148.camel@joe-AO722>
	 <20130903021207.GA4045@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 19:12 -0700, Josh Triplett wrote:
> On Mon, Sep 02, 2013 at 06:52:45PM -0700, Joe Perches wrote:
> > On Mon, 2013-09-02 at 18:34 -0700, Josh Triplett wrote:
> > > I'd suggest a couple more, which
> > > *should* always make sense, and to the best of my knowledge don't tend
> > > to generate false positives:

Hey Josh.

I don't want to enable too many types of messages
because the "barrier to entry" to submit patches
shouldn't be so high that it discourages people.

I feel mostly that many types of checkpatch messages
are OK to emit, but aren't necessary to fix and
people should feel that checkpatch isn't a necessary
thing to silence before patches are accepted.

cheers, Joe

