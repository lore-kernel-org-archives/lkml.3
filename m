Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaKZQGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:06:01 -0500
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:55091 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753154AbaKZQGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:06:00 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2565:2682:2685:2693:2828:2859:2908:2911:2916:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4425:5007:6261:7903:7974:9010:9025:9040:9388:10004:10049:10400:10450:10455:10848:11232:11658:11914:12043:12050:12292:12517:12519:12679:12682:12740:13161:13229:13255:13845:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wound94_8b31ec054484a
X-Filterd-Recvd-Size: 3680
Message-ID: <1417017955.19695.3.camel@perches.com>
Subject: Re: [PATCH] staging: media: lirc: lirc_zilog.c: fix quoted strings
 split across lines
From: Joe Perches <joe@perches.com>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jarod <jarod@wilsonet.com>, "m.chehab" <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "mahfouz.saif.elyazal" <mahfouz.saif.elyazal@gmail.com>,
        "dan.carpenter" <dan.carpenter@oracle.com>,
        "tuomas.tynkkynen" <tuomas.tynkkynen@iki.fi>,
        "gulsah.1004" <gulsah.1004@gmail.com>,
        linux-media <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Date: Wed, 26 Nov 2014 08:05:55 -0800
In-Reply-To: <CAPA4HGVJ_gJacLtgtQSJgSjgks9_7aGSuy2+aLOtkz01+Ng7CQ@mail.gmail.com>
References: <20141125201905.GA10900@biggie>
	 <1416947244.8358.12.camel@perches.com> <20141125204056.GA12162@biggie>
	 <1416949207.8358.14.camel@perches.com> <20141125211428.GA12346@biggie>
	 <1416966580.8358.17.camel@perches.com>
	 <CAPA4HGVJ_gJacLtgtQSJgSjgks9_7aGSuy2+aLOtkz01+Ng7CQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 15:42 +0000, Luis de Bethencourt wrote:
> On 26 November 2014 at 01:49, Joe Perches <joe@perches.com> wrote:
[]
> > There is a script I posted a while back that
> > groups various checkpatch "types" together and
> > makes it a bit easier to do cleanup style
> > patches.
> >
> > https://lkml.org/lkml/2014/7/11/794
> That is useful! I just run it on staging/octeon/ and it wrote two patches.
> Will submit them in a minute.

Please make sure and write better commit messages
than the script produces.

> > Using checkpatch to get familiar with kernel
> > development is fine and all, but fixing actual
> > defects and submitting new code is way more
> > useful.
[]
> I agree. I was just using checkpatch to learn about the development process.
> How to create patches, submit patches, follow review, and such. Better to
> do it
> with small changes like this first.

That's a good way to start.

> Which makes me wonder. Is my patch accepted? Will it be merged? I can do the
> proposed logging macro additions in a few days. Not sure yet how the final
> step of the process when patches get accepted and merged works.

You will generally get an email from a maintainer
when patches are accepted/rejected or you get
feedback asking for various changes.

Greg KH does that for drivers/staging but not for
drivers/staging/media.  Mauro Carvalho Chehab does.

These emails are not immediate.  It can take 2 or 3
weeks for a response.  Sometimes longer, sometimes
shorter, sometimes no response ever comes.

After a month or so, if you get no response, maybe
the maintainer never saw it.  You should maybe
expand the cc: list for the email.

When the patch is more than a trivial style cleanup,
Andrew Morton generally picks up orphan patches.

For some subsystems, there are "tracking" mechanisms
like patchwork:

For instance, netdev (net/ and drivers/net/) uses:
http://patchwork.ozlabs.org/project/netdev/list/
and David Miller, the primary networking maintainer
is very prompt about updating it.

There's this list of patchwork entries, but maintainer
activity of these lists vary:

https://patchwork.kernel.org/

