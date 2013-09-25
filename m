Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab3IYQTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:19:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36732 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3IYQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:19:53 -0400
Date: Wed, 25 Sep 2013 17:19:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch: Find CamelCase definitions of
 struct/union/enum
Message-ID: <20130925161949.GZ13318@ZenIV.linux.org.uk>
References: <1380047934.3575.100.camel@joe-AO722>
 <20130925152432.GY13318@ZenIV.linux.org.uk>
 <1380123344.17366.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380123344.17366.5.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 08:35:44AM -0700, Joe Perches wrote:

> We disagree.

Obviously.

> I think Propercase should be discouraged.
> ie: Qdisc et al.

Excuse me, but "Joe happens to think that something should be discouraged"
is not a problem.  "Joe uses checkpatch.pl as force multiplier, recruiting
hundreds of monkeys to enforce his personal preferences", OTOH, very much is.

You are calling for ban on any mixed-case identifiers.  I see at least three
cases where they can be legitimate:
	* labels a-la Enomem, etc.  I've been using those and I will
keep doing so, checkpatch.pl and its users be damned.
	* enum members, to distinguish those from defines (first letter
capitalized vs. all-caps).
	* (local) typedefs for structs; I really don't like their use for
anything non-local, but IMO they have their uses in cases like e.g.
fs/binfmt_misc.c
