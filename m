Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3JFVQc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:16:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38807 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab3JFVQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:16:31 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 14:16:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
Message-ID: <20131006211622.GA19510@leaf>
References: <20131005184307.GA6429@leaf>
 <1380999108.2081.138.camel@joe-AO722>
 <20131006062739.GA5218@kroah.com>
 <1381042912.2081.146.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381042912.2081.146.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 12:01:52AM -0700, Joe Perches wrote:
> On Sat, 2013-10-05 at 23:27 -0700, Greg Kroah-Hartman wrote:
> > On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > > > directing people to write to the FSF for a copy of the GPL, since the
> > > > FSF has moved in the past and may do so again.
> > > []
> > > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > []
> > > > +# Check for FSF mailing addresses.
> > > > +		if ($rawline =~ /You should have received a copy/ || 
> > > There are over 9,000 of these in the tree.
> > > > +		    $rawline =~ /write to the Free Software/ ||
> > > Over 7,000
> > > > +		    $rawline =~ /59 Temple Place/ ||
> > > Over 3,500
> > > > +		    $rawline =~ /51 Franklin Street/) {
> > > Over 1,500
> > 
> > Then we should remove them all.
> []
> > I don't want to see this get worse over time, Josh, thanks for doing
> > this checkpatch patch.
> 
> What about the warranty disclaimer?
> 
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.

That one doesn't cause any logistical problems the way the FSF's mailing
address does, and legal departments may be uncomfortable omitting it, so
I don't think it makes sense for checkpatch to flag it.

- Josh Triplett
