Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab3GCJu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:50:57 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:7844 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065Ab3GCJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:50:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlorAGbz01F5LNm+/2dsb2JhbABagwkyrHwCjk6FJQQBfhd0giMBAQUyASMjEAgDDgoJJQ8FJQMhE4gOunIWjjKBHQeDbQOXSZFGgyMq
Date: Wed, 3 Jul 2013 19:50:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Message-ID: <20130703095050.GN14996@dastard>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
 <20130703064026.GL14996@dastard>
 <c229feab100a72240128ef81297680a1@meuh.org>
 <20130703092406.GM14996@dastard>
 <5e9d66217e0fa968863177d73dd492b1@meuh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e9d66217e0fa968863177d73dd492b1@meuh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:36:39AM +0200, Yann Droneaud wrote:
> Le 03.07.2013 11:24, Dave Chinner a écrit :
> >On Wed, Jul 03, 2013 at 10:14:41AM +0200, Yann Droneaud wrote:
> >>Le 03.07.2013 08:40, Dave Chinner a écrit :
> >>>On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
> >>>>This patch changes type of xfs@oss.sgi.com
> >>>>
> >>>>The output of ./scripts/get_maintainer.pl is
> >>>>modified to report xfs@oss.sgi.com as a list:
> >>>
> >>>What's the problem with that? All XFS patches and problem
> >>>reports should be sent to the xfs@oss.sgi.com list. There are far
> >>>more people than just the maintainer that can triage problems,
> >>>answer questions and review patches...
> >>>
> >>
> >>It was just disturbing: I was looking for a list for XFS
> >>and found only maintainers.
> >
> >That's what the:
> >
> >L:      xfs@oss.sgi.com
> >
> >entry is, yes?
> >
> 
> In the output of ./scripts/get_maintainer.pl:
> 
> Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
> Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
> xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
> linux-kernel@vger.kernel.org (open list)

You're smarter than a dumb script. If the information that the
script parses is correct and the dumb script doesn't give you the
right information, then what needs fixing?

Seriously, all you are proving is the old adage that
scripts/get_maintainer.pl should be considered harmful because
people use it without first engaging their brain.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
