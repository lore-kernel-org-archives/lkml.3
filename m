Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaCKVwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:52:42 -0400
Received: from smtprelay0248.hostedemail.com ([216.40.44.248]:45623 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752081AbaCKVwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:52:41 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1476:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2540:2553:2561:2564:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3866:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:7652:7809:8985:9010:9025:9036:10004:10400:10848:11232:11658:11914:12043:12114:12296:12517:12519:12740:13069:13161:13229:13311:13357:14094,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: look68_6e6750f914d0e
X-Filterd-Recvd-Size: 1701
Message-ID: <1394574757.20021.19.camel@joe-AO722>
Subject: Re: [PATCH] MAINTAINERS: wimax@linuxwimax.org is subscribers-only
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: ellis@spinics.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Mar 2014 14:52:37 -0700
In-Reply-To: <CAMuHMdUJvukW7kwgTr49Atutgv71Ogt1uTYGz-Bawobfaa82gg@mail.gmail.com>
References: <CAMuHMdW0cojVgDmTK0nHpY=xGFkM=10fJFe=SFP6En8k7Uwxvw@mail.gmail.com>
	 <201403112127.s2BLRT40024536@amd.spinics.net>
	 <CAMuHMdUJvukW7kwgTr49Atutgv71Ogt1uTYGz-Bawobfaa82gg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 22:36 +0100, Geert Uytterhoeven wrote:
> On Tue, Mar 11, 2014 at 10:27 PM,  <ellis@spinics.net> wrote:
> >>>  W:     http://linuxwimax.org
> > That URL doesn't work. There's no address associated with the domain.
> That's material for another patch.
> Fortunately we're not pasting the URLs from get_maintainer.pl into
> git send-email.

The archive of the mailing list looks as if it's been
dead for years.

https://lists.linuxwimax.org/pipermail/wimax/

Inaky, is this still alive at all?

If not, I suggest orphaning both WIMAX STACK and the
INTEL WIRELESS WIMAX sections and removing Inaky
as maintainer.


