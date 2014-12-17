Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaLQRd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:33:59 -0500
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:38984 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751108AbaLQRd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:33:58 -0500
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Dec 2014 12:33:57 EST
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,realty@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:6691:7903:8700:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13019:13069:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burst02_1b7096b987645
X-Filterd-Recvd-Size: 2276
Message-ID: <1418837187.14140.22.camel@perches.com>
Subject: Re: [PATCH] checkpatch: enable MAINTAINERS warning only for
 --strict,--subjective
From: Joe Perches <realty@perches.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        Andy Whitcroft <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Dec 2014 09:26:27 -0800
In-Reply-To: <CAJiQ=7AxGdByudruUQtHMq-SNfmumPXP7EDzo-o2QyXWrMxv6A@mail.gmail.com>
References: <1418801732-19141-1-git-send-email-computersforpeace@gmail.com>
	 <1418808435.14140.16.camel@perches.com>
	 <CAJiQ=7AxGdByudruUQtHMq-SNfmumPXP7EDzo-o2QyXWrMxv6A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 07:53 -0800, Kevin Cernekee wrote:
> On Wed, Dec 17, 2014 at 1:27 AM, Joe Perches <joe@perches.com> wrote:
> > On Tue, 2014-12-16 at 23:35 -0800, Brian Norris wrote:
> >> The rule which delivers this warning is very prone to errors:
> >>   "added, moved or deleted file(s), does MAINTAINERS need updating?"
> >> so it should not be enabled by default.
> >
> > I don't think so.
> >
> > It's _far_ more common for people to forget to
> > update MAINTAINERS so I think it's quite useful
> > even if it's slightly noisy.
> 
> In a recent submission I saw a bunch of these warnings too, even
> though I had already added MAINTAINERS entries.
> 
> If this is just a friendly reminder ("hey, please double-check X
> before you send") rather than an indication that a suspected problem
> was detected in the patch, perhaps it would be better if it lived in
> Documentation/SubmitChecklist?

An entry might help.

Submit a patch to SubmitChecklist and see if the
overall MAINTAINERS patterns error rate changes
over a few release cycles.

Another thing that might help you not see these
by creating a .checkpatch.conf file and adding:
"--ignore=FILE_PATH_CHANGES"



