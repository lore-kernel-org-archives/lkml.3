Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaJNNoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 09:44:00 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:58537 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755275AbaJNNn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 09:43:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3870:3873:3876:4321:5007:6238:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: joke93_22779361bc648
X-Filterd-Recvd-Size: 1639
Message-ID: <1413294235.3269.4.camel@joe-AO725>
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Thomas Shao <huishao@microsoft.com>, tglx@linutronix.de,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, kys@microsoft.com
Date: Tue, 14 Oct 2014 06:43:55 -0700
In-Reply-To: <20141014111915.GV23154@mwanda>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
	 <20141014111915.GV23154@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 14:19 +0300, Dan Carpenter wrote:
> I had a couple small style nits.
> 
> On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > index 3b9c9ef..1d8390c 100644
> > --- a/drivers/hv/hv_util.c
> > +++ b/drivers/hv/hv_util.c
> > @@ -51,11 +51,30 @@
> >  #define HB_WS2008_MAJOR	1
> >  #define HB_WS2008_VERSION	(HB_WS2008_MAJOR << 16 | HB_MINOR)
> >  
> > +#define  TIMESAMPLE_INTERVAL 5000000000L  /* 5s in nanosecond */
> 
> If you wanted you could say:
> 
> #define  TIMESAMPLE_INTERVAL  (5 * NSEC_PER_SEC)

ULL


