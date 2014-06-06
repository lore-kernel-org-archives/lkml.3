Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaFFPei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:34:38 -0400
Received: from smtprelay0208.hostedemail.com ([216.40.44.208]:33483 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750874AbaFFPeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:34:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:901:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2525:2551:2553:2560:2563:2682:2685:2691:2828:2829:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3657:3742:3865:3866:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7576:7652:7903:7904:8599:8603:9007:9025:10004:10400:10482:10848:11232:11658:11854:11914:12043:12050:12517:12519:12740:12776:13069:13095:13311:13357:19901:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scene37_7bad52da42039
X-Filterd-Recvd-Size: 1793
Message-ID: <1402068842.12513.7.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
From: Joe Perches <joe@perches.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Date: Fri, 06 Jun 2014 08:34:02 -0700
In-Reply-To: <1402068405.12513.5.camel@joe-AO725>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
	 <1402068405.12513.5.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 08:26 -0700, Joe Perches wrote:
> On Fri, 2014-06-06 at 15:08 +0000, Allan, Bruce W wrote:
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Thursday, June 05, 2014 6:36 PM
> > > On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> > > > the maximum message size (100,000 characters) allowed by Majordomo at
> > > > vger.kernel.org since that is where most Linux email lists are served.
> > > I believe this is incorrect and the patch is unnecessary.
> > Actually, it is correct (it even says so at http://vger.kernel.org/majordomo-info.html).
> where?

Duh, near the very end it does have:

	Message size exceeding 100 000 characters causes blocking. 

But I believe that info is out of date.


