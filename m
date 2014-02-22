Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbaBVWat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:30:49 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56278 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaBVWas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:30:48 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 22 Feb 2014 14:30:38 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3] SubmittingPatches: Add recommendation for
 mailing list references
Message-ID: <20140222223038.GA4643@thin>
References: <6f68169828300d32c4266a6d68c5fcf272dfea33.1393099913.git.josh@joshtriplett.org>
 <02737d618daecb42e33308ce5dabd53ed3cf14f3.1393099913.git.josh@joshtriplett.org>
 <53091D26.4020900@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53091D26.4020900@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 01:56:54PM -0800, Randy Dunlap wrote:
> On 02/22/2014 12:12 PM, Josh Triplett wrote:
> > SubmittingPatches already mentions referencing bugs fixed by a commit,
> > but doesn't mention citing relevant mailing list discussions.  Add a
> > note to that effect, along with a recommendation to use the
> > https://lkml.kernel.org/ redirector.
> > 
> > Portions based on text from git's SubmittingPatches.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Borislav Petkov <bp@suse.de>
> > ---
> >  Documentation/SubmittingPatches | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> > index c74e73c..53e6590 100644
> > --- a/Documentation/SubmittingPatches
> > +++ b/Documentation/SubmittingPatches
> > @@ -112,7 +112,15 @@ to do frotz", as if you are giving orders to the codebase to change
> >  its behaviour.
> >  
> >  If the patch fixes a logged bug entry, refer to that bug entry by
> > -number and URL.
> > +number and URL.  If the patch follows from a mailing list discussion,
> > +give a URL to the mailing list archive; use the https://lkml.kernel.org/
> > +redirector with a Message-Id, to ensure that the links cannot become
> > +stale.
> 
> Some of us don't know what that looks like.
> Could we have an example?

https://lkml.kernel.org/ provides examples; I didn't want to duplicate
that documentation.

- Josh Triplett
