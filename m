Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaHNOfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:35:31 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:51323 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754628AbaHNOfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:35:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3871:3872:3873:4250:4321:5007:7576:7652:10004:10400:10848:10967:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: watch11_86f14d02d3461
X-Filterd-Recvd-Size: 1722
Message-ID: <1408026925.2683.24.camel@joe-AO725>
Subject: Re: [PATCH] locks: Remove unused conf argument from lm_grant
From: Joe Perches <joe@perches.com>
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kinglong Mee <kinglongmee@gmail.com>
Date: Thu, 14 Aug 2014 07:35:25 -0700
In-Reply-To: <20140814095658.1716c48e@tlielax.poochiereds.net>
References: <1408024360-5177-1-git-send-email-jlayton@primarydata.com>
	 <20140814095658.1716c48e@tlielax.poochiereds.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-14 at 09:56 -0400, Jeff Layton wrote:
> On Thu, 14 Aug 2014 09:52:40 -0400
> Jeff Layton <jlayton@primarydata.com> wrote:
> > From: Joe Perches <joe@perches.com>
> > This argument is always NULL so don't pass it around.
> > Signed-off-by: Joe Perches <joe@perches.com>
> > Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> > ---
> >  fs/dlm/plock.c     |  8 ++++----
> >  fs/lockd/svclock.c | 12 +++---------
> >  include/linux/fs.h |  2 +-
> >  3 files changed, 8 insertions(+), 14 deletions(-)
> Joe, if this looks OK with you, I'll plan to merge this for v3.18.

Looks fine, thanks Jeff.


