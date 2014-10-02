Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaJBUGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 16:06:55 -0400
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:46853 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752921AbaJBUGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 16:06:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3868:3870:3871:3872:3874:4250:4321:4605:5007:6119:7652:7903:8603:8957:10011:10400:10450:10455:10848:11232:11658:11914:12043:12438:12517:12519:12663:12740:13069:13311:13357:13972:14096:14097:19904:19999:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: water14_3bc3f7a36e620
X-Filterd-Recvd-Size: 2307
Message-ID: <1412280404.3247.77.camel@joe-AO725>
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        trivial@kernel.org, akpm@linux-foundation.org, arend@broadcom.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Oct 2014 13:06:44 -0700
In-Reply-To: <542DAEE9.7000906@infradead.org>
References: <542DA51C.1080209@free-electrons.com>
	 <1412277870-4960-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <542DAEE9.7000906@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 13:00 -0700, Randy Dunlap wrote:
> One more then I'm done.
[]
> On 10/02/14 12:24, Michael Opdenacker wrote:
[]
> > diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
[]
> > @@ -830,14 +830,14 @@ ENDPROC(unrecoverable_exception)
> >   * of the proper size instead.
> >   *
> >   * This algorithm simply backs out the register changes started by the user
> > - * excpetion handler, makes it appear that we have started a window underflow
> > + * exception handler, makes it appear that we have started a window underflow
> >   * by rotating the window back and then setting the old window base (OWB) in
> >   * the 'ps' register with the rolled back window base. The 'movsp' instruction
> >   * will be re-executed and this time since the next window frames is in the
> >   * active AR registers it won't cause an exception.
> >   *
> >   * If the WindowUnderflow code gets a TLB miss the page will get mapped
> > - * the the partial windeowUnderflow will be handeled in the double exception
> > + * and the partial windeowUnderflow will be handled in the double exception
> 
>                       windowUnderflow

I think both of these might be better as "window underflow"
as it's used in the second line of the previous paragraph.

