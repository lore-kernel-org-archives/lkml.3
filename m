Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3JGVXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:23:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57452 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3JGVXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:23:07 -0400
Date: Mon, 7 Oct 2013 22:23:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
        gregkh@linux-foundation.org, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict
 check only
Message-ID: <20131007212302.GB13318@ZenIV.linux.org.uk>
References: <20131007191835.GA28737@jtriplet-mobl1>
 <1381174106.2081.207.camel@joe-AO722>
 <20131007193433.GF13643@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007193433.GF13643@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 12:34:33PM -0700, Josh Triplett wrote:

> I've seen far more examples of the 80-column limit making code less
> readable rather than more.  It's only really helpful when it forces code
> restructuring, *not* when it just forces an arbitrary line break.

So teach that piece of crap to complain about fucked-in-head line breaks like
							ret_val =
							    leaf_shift_left(tb,
									    tb->
									    lnum
									    [0],
									    tb->
									    lbytes
									    -
									    1);
in addition to obscenely long lines (and yes, it is a real-world example).

The one and only point of such tools is to help locating the crappy code.
And that's the only sane criterion for evaluating new "stylistic rules" -
does that particular heuristic catch enough shitty places or not?

_Anything_ can be obfuscated to the point where warnings are not produced
anymore...
