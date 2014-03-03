Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaCCHKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:10:07 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:56082 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753638AbaCCHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:10:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:152:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3622:3865:3867:3870:3871:3872:4321:5007:6119:7652:7903:8957:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sort36_57bd40a23ff29
X-Filterd-Recvd-Size: 1663
Message-ID: <1393830601.13719.77.camel@joe-AO722>
Subject: Re: [PATCH 3/5 v2] Staging: cxt1e1: Fix line length over 80
 characters in hwprobe.c
From: Joe Perches <joe@perches.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Greg KH <gregkh@linuxfoundation.org>,
        "sachin.kamat" <sachin.kamat@linaro.org>,
        Shaun Laing <shaun@xresource.ca>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 02 Mar 2014 23:10:01 -0800
In-Reply-To: <CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
References: <3980699.cFzmTHesZE@daeseok-laptop.cloud.net>
	 <m3bnxnpyok.fsf@t19.piap.pl>
	 <CAHb8M2AS2w9VBSJS9imU07ydMOZW+M-PD-Ja3iZYSTJ=2GNa-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 16:01 +0900, DaeSeok Youn wrote:
> 2014-03-03 15:46 GMT+09:00 Krzysztof Hałasa <khalasa@piap.pl>:
> > why not use some existing *hex_dump*() instead?
> OK. but this patch is only for fix line length over 80 characters,
> right? If it can be improved as your comment,
> it must be in another patch.

Not true.  Always strive to improve the code in
preference to shutting up checkpatch warnings.


