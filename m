Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaFZEnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 00:43:37 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60526 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaFZEng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 00:43:36 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 21:43:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Greg KH <gregkh@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626044327.GA1645@thin>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
 <20140626035959.GE904@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626035959.GE904@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:59:59PM -0400, Greg KH wrote:
> On Wed, Jun 25, 2014 at 07:24:49PM -0700, Josh Triplett wrote:
> > On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > > Regardless of the long-standing debate over line width, checkpatch
> > > > should not warn about it by default.
> > > 
> > > I'm not getting involved here.
> > > 
> > > I don't care much one way or another.
> > > 
> > > I did submit a patch where I ignored 80
> > > columns recently and I was told to try
> > > again by the maintainer.
> > 
> > I'm not asking you to get involved in the Great Line Length Debate;
> > that's why I didn't attempt to patch CodingStyle or similar.  However, I
> > think it makes sense for *checkpatch* to stop emitting this warning.
> > 
> > I'm hoping that Greg will chime in, as the maintainer of staging and the
> > recipient of a huge number of checkpatch-motivated patches.
> 
> I have no problem with the existing checkpatch.pl tool and it calling
> out 80 columns as a problem that needs to be fixed.  So I don't like
> this patch at all.

I'd like to stop seeing patches go by that produce heavily over-wrapped
code that becomes less readable; it's far easier to fix checkpatch than
to tell people to ignore its false positives.

How would you feel about a patch that flagged long lines with a warning
in patch mode, but not in file mode?

- Josh Triplett
