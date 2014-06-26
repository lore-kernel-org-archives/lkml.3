Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972AbaFZEAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 00:00:16 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60836 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721AbaFZEAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 00:00:14 -0400
X-Sasl-enc: wMgnNg7T+HhGFE+P6d1Cuji8bKcQWxOmTygcMUMn06wt 1403755210
Date: Wed, 25 Jun 2014 23:59:59 -0400
From: Greg KH <gregkh@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626035959.GE904@kroah.com>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626022448.GA22091@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 07:24:49PM -0700, Josh Triplett wrote:
> On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > Regardless of the long-standing debate over line width, checkpatch
> > > should not warn about it by default.
> > 
> > I'm not getting involved here.
> > 
> > I don't care much one way or another.
> > 
> > I did submit a patch where I ignored 80
> > columns recently and I was told to try
> > again by the maintainer.
> 
> I'm not asking you to get involved in the Great Line Length Debate;
> that's why I didn't attempt to patch CodingStyle or similar.  However, I
> think it makes sense for *checkpatch* to stop emitting this warning.
> 
> I'm hoping that Greg will chime in, as the maintainer of staging and the
> recipient of a huge number of checkpatch-motivated patches.

I have no problem with the existing checkpatch.pl tool and it calling
out 80 columns as a problem that needs to be fixed.  So I don't like
this patch at all.

greg k-h
