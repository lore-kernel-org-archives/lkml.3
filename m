Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbaCXVfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:35:21 -0400
Received: from smtprelay0090.hostedemail.com ([216.40.44.90]:58049 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750828AbaCXVfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:35:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3871:3872:4321:4552:5007:6691:7652:9545:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:130
X-HE-Tag: sofa37_854514410953e
X-Filterd-Recvd-Size: 1633
Message-ID: <1395696913.13968.67.camel@joe-AO722>
Subject: Re: [PATCH] staging: line6: Fix missing blanks after declarations
From: Joe Perches <joe@perches.com>
To: Fabian Mewes <architekt@coding4coffee.org>
Cc: gregkh@linuxfoundation.org, ashvinivaratharaj@gmail.com,
        cbajumpa@gmail.com, rashika.kheria@gmail.com, berardi.dav@gmail.com,
        monamagarwal123@gmail.com, lisa@xenapiadmin.com,
        ebru.akagunduz@gmail.com, stefanha@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2014 14:35:13 -0700
In-Reply-To: <1395694265-2133-1-git-send-email-architekt@coding4coffee.org>
References: <1395694265-2133-1-git-send-email-architekt@coding4coffee.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-24 at 21:51 +0100, Fabian Mewes wrote:
> This patch is part of eudyptula challenge task 10
> 
> Signed-off-by: Fabian Mewes <architekt@coding4coffee.org>

Hi Fabian.

The patch seems fine, but please do not use something
like the above as a commit message.

It would be better to describe _why_ the change should
be done.  Something like:

------

Subject: [PATCH] staging: line6: Add blank lines after declarations

Use the more common kernel coding style.

Signed-off-by: your name <your.email@domain.tld>

