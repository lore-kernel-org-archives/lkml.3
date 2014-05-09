Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaEIUYo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:24:44 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:47158 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756929AbaEIUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:24:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2911:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3873:4321:4425:5007:7652:7875:8603:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13069:13071:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flag58_be42c0d5c25b
X-Filterd-Recvd-Size: 1586
Message-ID: <1399667080.2912.6.camel@joe-AO725>
Subject: Re: [PATCH] drivers: staging: ft1000: Improve coding style
From: Joe Perches <joe@perches.com>
To: Artem Fetishev <wwctrsrx@gmail.com>
Cc: marek.belisko@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Fri, 09 May 2014 13:24:40 -0700
In-Reply-To: <1399704813-9516-1-git-send-email-wwctrsrx@gmail.com>
References: <1399704813-9516-1-git-send-email-wwctrsrx@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-05-10 at 09:53 +0300, Artem Fetishev wrote:
> Improvements include:
>  - Lines over 80 characters;
>  - Use pr_info() instead printk(KERN_INFO);
>  - Removal of typedefs;
>  - Indentation.
>  - Fix IOCTL_FT1000_* marcos:
>    - Add closing brackets;
>    - remove sizeof (_IOR and _IOW macro can accept types);
>    - replace _IOW which size of 0 (the last arg) with _IO.
>    - Actually these macros are not used anywhere and might be removed.

Hello Artem.

All of these are nice little fixes, but combined,
they are difficult to review.

Could you please separate them into multiple patches,
one per line item entry?

Maybe reorder them too doing the indentation fix
first and leaving the 80 column changes until last.

