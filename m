Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaCJUMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:12:02 -0400
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:56548 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751818AbaCJUMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:12:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4250:4321:4605:5007:7652:8603:10004:10226:10400:10450:10455:10848:11026:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: walk70_2e3b50fbf8136
X-Filterd-Recvd-Size: 1905
Message-ID: <1394482316.21085.8.camel@joe-AO722>
Subject: Re: Treewide frequency of various checkpatch messages
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, apw@canonical.com,
        devel@linuxdriverproject.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 10 Mar 2014 13:11:56 -0700
In-Reply-To: <20140310193346.GA2850@kroah.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	 <1394104390-23477-1-git-send-email-kys@microsoft.com>
	 <20140306.142919.763823800315842610.davem@davemloft.net>
	 <1394148520.16156.8.camel@joe-AO722> <20140307075247.GA29018@mwanda>
	 <1394184637.16156.58.camel@joe-AO722> <1394467346.24244.14.camel@joe-AO722>
	 <20140310165046.GA12687@kroah.com> <1394477330.24244.34.camel@joe-AO722>
	 <20140310193346.GA2850@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 12:33 -0700, Greg KH wrote:
> On Mon, Mar 10, 2014 at 11:48:50AM -0700, Joe Perches wrote:
[]
> > I've no strong opinion of the need to write code
> > like:
> > 
> > {
> >         u32 iterations = 0;
> > 
> >         while (arch_spin_is_locked(lock))
> >                 delay_backoff(iterations++);
> > }
> 
> I wonder if there's a way to "count" the size of the function, and only
> complain if it's longer than 4-5 lines long?

No, there's isn't really.
checkpatch works on patch hunks.
The function scope isn't necessarily visible.


