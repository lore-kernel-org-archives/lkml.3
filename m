Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaJ1Rlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:41:40 -0400
Received: from tex.lwn.net ([70.33.254.29]:44447 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaJ1Rli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:41:38 -0400
Date: Tue, 28 Oct 2014 13:41:35 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] Documentation/SubmittingPatches: Reported-by tags and
 permission
Message-ID: <20141028134135.59dbc512@lwn.net>
In-Reply-To: <20141028165827.GG15252@titan.lakedaemon.net>
References: <1392333751.29034.3.camel@x220>
	<20140214093001.GA15933@elgon.mountain>
	<20141028090451.41ed6aad@lwn.net>
	<20141028165827.GG15252@titan.lakedaemon.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014 12:58:27 -0400
Jason Cooper <jason@lakedaemon.net> wrote:

> At the risk of upsetting the apple cart, I'd prefer we downplay anything
> that walks down the path of gamification (by focusing on credit).
> 
> As best anyone has ever explained it to me, the Acked-by, Reviewed-by,
> etc are there to impart information regarding a specific commit.  In the
> event that a commit is fingered in a bisect, you have a much better list
> of names to Cc, instead of just the maintainer from MAINTAINERS and the
> author from the top of the offending file.  The author has often moved
> on, and the maintainer may not have been around for the bugfix.

As I understand it, having been in the room when these tags were
developed and encouraged, was that credit was a big part of the initial
motivation.  We need more testers and bug reporters; this was a way to
give them credit for the valuable work that they do.  I still think
that's important, for whatever that's worth.

> I know Greg has spoken out against gamification before, and I also
> understand the desire to encourage bug reporters.  Perhaps I should just
> suggest the following:
> 
> """
> The Reported-by tag helps us maintain contact info for people with
> intimate knowledge of a commit or a bug fix.  Please seek the reporter's
> permission before adding the tag to the commit.  That said, if we
> diligently credit our bug reporters, they will, hopefully, be inspired
> to help us again in the future.
> """

That addresses my concern, but loses the point of the initial patch:
publicly reporting a bug can be seen as implicit permission to credit the
reporter.

Thanks,

jon
