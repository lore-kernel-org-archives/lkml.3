Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab3GCJYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 05:24:14 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:38214 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515Ab3GCJYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 05:24:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmErAF3s01F5LNm+/2dsb2JhbABagwkyrHwCjk6FIQQEAX4XdIIjAQEFMgEjIxAIAw4KCSUPBSUDIROIDrpzFo4ygR0Hg20Dl0mRRoMjKg
Date: Wed, 3 Jul 2013 19:24:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Message-ID: <20130703092406.GM14996@dastard>
References: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
 <20130703064026.GL14996@dastard>
 <c229feab100a72240128ef81297680a1@meuh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c229feab100a72240128ef81297680a1@meuh.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 10:14:41AM +0200, Yann Droneaud wrote:
> Hi,
> 
> Le 03.07.2013 08:40, Dave Chinner a écrit :
> >On Tue, Jul 02, 2013 at 05:00:47PM +0200, Yann Droneaud wrote:
> >>This patch changes type of xfs@oss.sgi.com
> >>
> >>The output of ./scripts/get_maintainer.pl is
> >>modified to report xfs@oss.sgi.com as a list:
> >
> >What's the problem with that? All XFS patches and problem
> >reports should be sent to the xfs@oss.sgi.com list. There are far
> >more people than just the maintainer that can triage problems,
> >answer questions and review patches...
> >
> 
> It was just disturbing: I was looking for a list for XFS
> and found only maintainers.

That's what the:

L:      xfs@oss.sgi.com

entry is, yes?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
