Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbaJANc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:32:57 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:47740 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751712AbaJANcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:32:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3868:3870:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12291:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit51_362d74cc3a40d
X-Filterd-Recvd-Size: 1342
Message-ID: <1412170370.3247.2.camel@joe-AO725>
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
From: Joe Perches <joe@perches.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: trivial@kernel.org, akpm@linux-foundation.org, arend@broadcom.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Wed, 01 Oct 2014 06:32:50 -0700
In-Reply-To: <1412157182-6852-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393998723-4475-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <1412157182-6852-1-git-send-email-michael.opdenacker@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 11:53 +0200, Michael Opdenacker wrote:
> Fix all occurrences of "the the " in the source code,
> comments and documentation.

[]
>  drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c | 1486 ++++++++++++++++++++

That one snuck in here where it doesn't belong.

Please fix and resubmit?

