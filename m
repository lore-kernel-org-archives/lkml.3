Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3JBOuR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:50:17 -0400
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:49726 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753071Ab3JBOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:50:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:967:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7652:7903:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: card96_3ba85aa94c313
X-Filterd-Recvd-Size: 1455
Message-ID: <1380725409.2081.44.camel@joe-AO722>
Subject: Re: [[RFC]] scripts/robopatch.pl: the mechanical bride of
 checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Andi Shyti <andi@etezian.org>
Cc: Phil Carmody <phil.carmody@partner.samsung.com>, apw@canonical.com,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 07:50:09 -0700
In-Reply-To: <20131002120630.GA4179@jack.whiskey>
References: <1375784829-5974-1-git-send-email-phil.carmody@partner.samsung.com>
	 <20131002120630.GA4179@jack.whiskey>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 14:06 +0200, Andi Shyti wrote:
> > +# $ scripts/checkpatch.pl WHATEVER > /tmpcheckpatch.log
>                                            ^^
> I guess you have a typo here.
> 
> I actually used this, it doesn't know what msleep is and it
> fails, so that to go ahead I had to remove the msleep lines from
> /tmp/checpatch.log.

robopatch has some promise.

Please also give a try of linux-next tree's version of
./scripts/checkpatch.pl using the --fix option.

Maybe use this script too:

https://lkml.org/lkml/2013/9/23/504


