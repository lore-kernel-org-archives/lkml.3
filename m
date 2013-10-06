Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3JFVTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:19:06 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56645 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3JFVTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:19:04 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 14:18:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006211855.GB19510@leaf>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006062739.GA5218@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 11:27:39PM -0700, Greg Kroah-Hartman wrote:
> On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > > directing people to write to the FSF for a copy of the GPL, since the
> > > FSF has moved in the past and may do so again.
> > []
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> > > @@ -1859,6 +1859,16 @@ sub process {
> > >  			$rpt_cleaners = 1;
> > >  		}
> > >  
> > > +# Check for FSF mailing addresses.
> > > +		if ($rawline =~ /You should have received a copy/ ||
> > 
> > There are over 9,000 of these in the tree.
> > 
> > > +		    $rawline =~ /write to the Free Software/ ||
> > 
> > Over 7,000
> > 
> > > +		    $rawline =~ /59 Temple Place/ ||
> > 
> > Over 3,500
> > 
> > > +		    $rawline =~ /51 Franklin Street/) {
> > 
> > Over 1,500
> 
> Then we should remove them all.  I know some FSF members have tried to
> do a sweep of the kernel tree at times to at least get rid of the old
> physical address, but it looks like that didn't work very well.
> 
> I don't want to see this get worse over time, Josh, thanks for doing
> this checkpatch patch.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, Greg!

Given this ack, any objections to merging the patch in its current form?

- Josh Triplett
