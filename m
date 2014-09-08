Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaIHPle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:41:34 -0400
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:58551 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753833AbaIHPlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:41:32 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3870:3873:3874:4321:5007:7514:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13071:13311:13357:21060:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sack33_818165f976a0e
X-Filterd-Recvd-Size: 1536
Message-ID: <1410190888.12560.15.camel@joe-AO725>
Subject: Re: [PATCH] staging: binder: fix coding style issues
From: Joe Perches <joe@perches.com>
To: Dmitry Voytik <voytikd@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2014 08:41:28 -0700
In-Reply-To: <1410185794-16160-1-git-send-email-voytikd@gmail.com>
References: <1410184684.12560.11.camel@joe-AO725>
	 <1410185794-16160-1-git-send-email-voytikd@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-08 at 18:16 +0400, Dmitry Voytik wrote:
> Fix coding style issues:
> * put braces in all if-else branches;
> * limit the length of changed lines to 80 columns.
> checkpatch.pl warning count reduces by 3.
> 
> Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
> Reviewed-by: Joe Perches <joe@perches.com>

Hi Dmitry.

I don't see any defect in your patch now but here's
a bit of trivia for you.

I didn't sign anything here.

Please don't add signatures from another person unless
or until specifically written by that other person.

cheers, Joe

