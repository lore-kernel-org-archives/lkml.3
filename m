Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaEGSA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:00:56 -0400
Received: from smtprelay0155.hostedemail.com ([216.40.44.155]:52480 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752038AbaEGSAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:00:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:5007:7652:9010:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scent96_5deb85558ab4c
X-Filterd-Recvd-Size: 1962
Message-ID: <1399485643.2911.12.camel@joe-AO725>
Subject: Re: [PATCH] MAINTAINERS: Add linux-api for review of API/ABI changes
From: Joe Perches <joe@perches.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Wed, 07 May 2014 11:00:43 -0700
In-Reply-To: <5369C37A.1000001@gmail.com>
References: <20140506205953.GA16997@jtriplet-mobl1>
	 <5369C37A.1000001@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-07 at 07:24 +0200, Michael Kerrisk (man-pages) wrote:
> On 05/06/2014 10:59 PM, Josh Triplett wrote:
> > This makes it more likely that patch submitters will CC API/ABI changes
> > to the linux-api list, and tools like get_maintainer.pl will do so
> > automatically.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Every little bit helps, I guess. However, what I think would make a difference
> is if if people constantly posted reminders to CC linux-api when they see API/API
> changes on the lists. (And the reminders should of course CC linux-api).
[]
> > diff --git a/MAINTAINERS b/MAINTAINERS
[]
> > +ABI/API
> > +L:	linux-api@vger.kernel.org
> > +F:	Documentation/ABI/
> > +F:	include/linux/syscalls.h
> > +F:	include/uapi/
> > +F:	kernel/sys_ni.c

Perhaps this should have a
	"S:	Odd Fixes"
line too.


