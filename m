Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaJ1Q6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:58:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16388 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaJ1Q6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:58:36 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/CSrwGEbk8DZIeqYR53akrtZbtNGMDRJo=
X-DKIM: OpenDKIM Filter v2.0.1 titan 83A5560ACC8
Date: Tue, 28 Oct 2014 12:58:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] Documentation/SubmittingPatches: Reported-by tags and
 permission
Message-ID: <20141028165827.GG15252@titan.lakedaemon.net>
References: <1392333751.29034.3.camel@x220>
 <20140214093001.GA15933@elgon.mountain>
 <20141028090451.41ed6aad@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028090451.41ed6aad@lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:04:51AM -0400, Jonathan Corbet wrote:
> On Fri, 14 Feb 2014 12:30:01 +0300
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> > -If this patch fixes a problem reported by somebody else, consider adding a
> > -Reported-by: tag to credit the reporter for their contribution.  Please
> > -note that this tag should not be added without the reporter's permission,
> > -especially if the problem was not reported in a public forum.  That said,
> > -if we diligently credit our bug reporters, they will, hopefully, be
> > -inspired to help us again in the future.
> > +The Reported-by tag is to give credit to people who find bugs and report them.
> > +Please note that if the bug was reported in private, then ask for permission
> > +first before using the Reported-by tag.
> 
> As the guy who wrote the original text, I think this is an
> improvement...but can we get a version that retains the motivation for
> crediting bug reporters in the first place?

At the risk of upsetting the apple cart, I'd prefer we downplay anything
that walks down the path of gamification (by focusing on credit).

As best anyone has ever explained it to me, the Acked-by, Reviewed-by,
etc are there to impart information regarding a specific commit.  In the
event that a commit is fingered in a bisect, you have a much better list
of names to Cc, instead of just the maintainer from MAINTAINERS and the
author from the top of the offending file.  The author has often moved
on, and the maintainer may not have been around for the bugfix.

I know Greg has spoken out against gamification before, and I also
understand the desire to encourage bug reporters.  Perhaps I should just
suggest the following:

"""
The Reported-by tag helps us maintain contact info for people with
intimate knowledge of a commit or a bug fix.  Please seek the reporter's
permission before adding the tag to the commit.  That said, if we
diligently credit our bug reporters, they will, hopefully, be inspired
to help us again in the future.
"""

It's most likely ok here since it's rather hard to manufacture a list of
bugs in order to inflate ones count of Reported-by's.  Unlike S-o-b,
Ack's, etc.

thx,

Jason.
