Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3IXWWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:22:33 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:36089 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754630Ab3IXWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:22:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2909:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:3
X-HE-Tag: sheep09_329388baf343d
X-Filterd-Recvd-Size: 2399
Message-ID: <1380061346.17366.1.camel@joe-AO722>
Subject: Re: [PATCH 02/10] intel: Remove extern from function prototypes
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Tue, 24 Sep 2013 15:22:26 -0700
In-Reply-To: <1380060449.2189.6.camel@jtkirshe-mobl>
References: <cover.1380056108.git.joe@perches.com>
	 <5ccc921af41a862fe969809228f029035f851502.1380056108.git.joe@perches.com>
	 <1380060449.2189.6.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2013-09-24 at 15:07 -0700, Jeff Kirsher wrote:
> On Tue, 2013-09-24 at 14:09 -0700, Joe Perches wrote:
> > There are a mix of function prototypes with and without extern
> > in the kernel sources.  Standardize on not using extern for
> > function prototypes.
> > 
> > Function prototypes don't need to be written with extern.
> > extern is assumed by the compiler.  Its use is as unnecessary as
> > using auto to declare automatic/local variables in a block.
> 
> So you are able to confirm that all compilers make this assumption
> correctly?  The initial reason for using extern was because not all
> compilers made the assumption or made it correctly.

No, I didn't bother.

Any current compilers already do make this assumption
valid as it's been part of the c spec since 1989 and
prototypes without extern already are the predominate
form in .h files for linux kernel sources.

Even in drivers/net/ethernet/intel/... there are more
prototypes without extern than with extern.



