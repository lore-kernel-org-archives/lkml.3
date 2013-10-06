Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab3JFHB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 03:01:56 -0400
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:60192 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751436Ab3JFHBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 03:01:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:966:968:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3698:3742:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:6120:6755:7652:7809:7901:10004:10226:10400:10450:10455:10848:11232:11658:11914:12219:12517:12519:12740:13069:13311:13357:13523:13524:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: taste37_84e623bab7832
X-Filterd-Recvd-Size: 2152
Message-ID: <1381042912.2081.146.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Date: Sun, 06 Oct 2013 00:01:52 -0700
In-Reply-To: <20131006062739.GA5218@kroah.com>
References: <20131005184307.GA6429@leaf>
	 <1380999108.2081.138.camel@joe-AO722> <20131006062739.GA5218@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-10-05 at 23:27 -0700, Greg Kroah-Hartman wrote:
> On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > Kernel maintainers reject new instances of the GPL boilerplate paragraph
> > > directing people to write to the FSF for a copy of the GPL, since the
> > > FSF has moved in the past and may do so again.
> > []
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > []
> > > +# Check for FSF mailing addresses.
> > > +		if ($rawline =~ /You should have received a copy/ || 
> > There are over 9,000 of these in the tree.
> > > +		    $rawline =~ /write to the Free Software/ ||
> > Over 7,000
> > > +		    $rawline =~ /59 Temple Place/ ||
> > Over 3,500
> > > +		    $rawline =~ /51 Franklin Street/) {
> > Over 1,500
> 
> Then we should remove them all.
[]
> I don't want to see this get worse over time, Josh, thanks for doing
> this checkpatch patch.

What about the warranty disclaimer?

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


