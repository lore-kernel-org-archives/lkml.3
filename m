Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbaKEWWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:22:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaKEWWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:22:47 -0500
Date: Wed, 5 Nov 2014 23:22:46 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Subject: Re: [PATCH v2 05/13] backports: use BACKPORT_DIR prefix on kconfig
	sources
Message-ID: <20141105222246.GT12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com> <1415157517-15442-6-git-send-email-mcgrof@do-not-panic.com> <1415173905.2589.5.camel@sipsolutions.net> <20141105201105.GO12953@wotan.suse.de> <1415222354.7485.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415222354.7485.12.camel@sipsolutions.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 10:19:14PM +0100, Johannes Berg wrote:
> On Wed, 2014-11-05 at 21:11 +0100, Luis R. Rodriguez wrote:
> 
> > This does mean that bp_prefix topic *can* also be tied down
> > with this other directory prefix as a form of 'builder' for
> > integration. Making the prefix configurable would make sense
> > then only if also making the directory prefix should be
> > configurable.
> 
> Indeed.
> 
> > I think we're better off right now with just supporting two
> > approaches with their own directory prefix, and prefixes
> > for variables.
> 
> Sure, that's fine. I have no issues with either, but I'd like to see the
> two cases actually combined and separated, in the sense that you don't
> have magic code that tries both and just succeeds on one, but only have
> code that tries the right thing.

Fair enough.

 Luis
