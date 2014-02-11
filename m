Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaBKAUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:20:34 -0500
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:47131 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752850AbaBKAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:20:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2693:2828:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3872:3873:4184:4321:4362:4425:4605:5007:7652:7903:8957:10004:10400:10848:11232:11657:11658:11914:12043:12296:12517:12519:12740:13019:13069:13071:13161:13163:13229:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:no
X-HE-Tag: wave46_3f328a606e50
X-Filterd-Recvd-Size: 2654
Message-ID: <1392078024.2507.34.camel@joe-AO722>
Subject: Re: [Resend PATCH] staging : ion : Fix some checkpatch warnings and
 an error
From: Joe Perches <joe@perches.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Zavin <rebecca@android.com>, ccross@android.com,
        ohaugan@codeaurora.org, Rom Lemarchand <romlem@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 10 Feb 2014 16:20:24 -0800
In-Reply-To: <CAHb8M2DZHv7qsnt8RxAKyycMptyvKbfZcCtwV4juTs4jRp_z-A@mail.gmail.com>
References: <1861074.WmPcbRBdNV@daeseok-laptop.cloud.net>
	 <1392050018.2507.6.camel@joe-AO722>
	 <CAHb8M2DZHv7qsnt8RxAKyycMptyvKbfZcCtwV4juTs4jRp_z-A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 09:11 +0900, DaeSeok Youn wrote:
> Hi,

Hello.

> Thanks for review.
> If I send this patch again, i will use a subject as you comment.

Thanks.

> And alignment issue, my patch line seems to be same with your example.

You took out a space from the line with the function pointer
but not from the subsequent lines of the arguments.

> >> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> > []
> >> @@ -55,7 +55,7 @@ struct ion_device {
> >>       struct mutex buffer_lock;
> >>       struct rw_semaphore lock;
> >>       struct plist_head heaps;
> >> -     long (*custom_ioctl) (struct ion_client *client, unsigned int cmd,
> >> +     long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
> >>                             unsigned long arg);
> >
> > Please realign the arguments to the open parenthesis like:
> >
> >         long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
> >                              unsigned long arg);

Your patch has:

	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
			      unsigned long arg);

it should be:

	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
			     unsigned long arg);

with the "unsigned long arg" aligned immediately after
the open parenthesis of the function arguments.

(under the "s" of struct, not the first "t" of struct)



