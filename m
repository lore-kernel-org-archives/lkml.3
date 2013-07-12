Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab3GLBPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:15:18 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56578 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab3GLBPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:15:16 -0400
Message-ID: <1373592023.7397.465.camel@haakon3.risingtidesystems.com>
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Thu, 11 Jul 2013 18:20:23 -0700
In-Reply-To: <20130712005023.GB31005@thunk.org>
References: <20130711214830.611455274@linuxfoundation.org>
	 <20130712005023.GB31005@thunk.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 20:50 -0400, Theodore Ts'o wrote:
> On Thu, Jul 11, 2013 at 03:01:17PM -0700, Greg Kroah-Hartman wrote:
> > <rant>
> >   I'm sitting on top of over 170 more patches that have been marked for
> >   the stable releases right now that are not included in this set of
> >   releases.  The fact that there are this many patches for stable stuff
> >   that are waiting to be merged through the main -rc1 merge window cycle
> >   is worrying to me.
> > 
> >   Why are subsystem maintainers holding on to fixes that are
> >   _supposedly_ affecting all users?  I mean, 21 powerpc core changes
> >   that I don't see until a -rc1 merge?  It's as if developers don't
> >   expect people to use a .0 release and are relying on me to get the
> >   fixes they have burried in their trees out to users.  That's not that
> >   nice.  6 "core" iscsi-target fixes?  That's the sign of either a
> >   broken subsystem maintainer, or a lack of understanding what the
> >   normal -rc kernel releases are supposed to be for.
> 

In my defense here, the patches that have been CC'ed to 3.10.y stable
are to address bugs in iser-target, and it's interaction with existing
iscsi-target code after the large set of refactoring changes went in to
support multi-transport operation.

The reasons that they where not included in a v3.10-rc pull request is
because the bugs where found sufficiently late enough in the cycle, and
required large enough changes plus a non trival amount of manual failure
injection testing to verify their correctness.

--nab

