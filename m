Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaBVWj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:39:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaBVWj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:39:58 -0500
Date: Sat, 22 Feb 2014 23:39:47 +0100
From: Borislav Petkov <bp@suse.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3] SubmittingPatches: Add recommendation for
 mailing list references
Message-ID: <20140222223947.GB2534@pd.tnic>
References: <6f68169828300d32c4266a6d68c5fcf272dfea33.1393099913.git.josh@joshtriplett.org>
 <02737d618daecb42e33308ce5dabd53ed3cf14f3.1393099913.git.josh@joshtriplett.org>
 <53091D26.4020900@infradead.org>
 <20140222223038.GA4643@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140222223038.GA4643@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 02:30:38PM -0800, Josh Triplett wrote:
> > >  If the patch fixes a logged bug entry, refer to that bug entry by
> > > -number and URL.
> > > +number and URL.  If the patch follows from a mailing list discussion,
> > > +give a URL to the mailing list archive; use the https://lkml.kernel.org/
> > > +redirector with a Message-Id, to ensure that the links cannot become
> > > +stale.
> > 
> > Some of us don't know what that looks like.
> > Could we have an example?
> 
> https://lkml.kernel.org/ provides examples; I didn't want to duplicate
> that documentation.

Yeah, maybe you should say:

"If the patch follows from a mailing list discussion, give a URL to the
mailing list archive; use the https://lkml.kernel.org/ (usage examples
at that very URL) ... "

so that it is crystal clear.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
