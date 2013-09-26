Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3IZSDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:03:06 -0400
Received: from smtprelay0190.hostedemail.com ([216.40.44.190]:42494 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752223Ab3IZSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:03:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3868:3870:3872:3874:4321:5007:7576:7652:10004:10400:10848:10967:11232:11657:11658:11914:12517:12519:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: way22_54220f6b6f74d
X-Filterd-Recvd-Size: 1717
Message-ID: <1380218576.17366.76.camel@joe-AO722>
Subject: Re: [PATCH 00/11 - GIT PULL] drivers: net: Last block of Remove
 extern from function prototypes
From: Joe Perches <joe@perches.com>
To: David Miller <davem@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, wimax@linuxwimax.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, brcm80211-dev-list@broadcom.com
Date: Thu, 26 Sep 2013 11:02:56 -0700
In-Reply-To: <20130926.134408.91633054642517467.davem@redhat.com>
References: <cover.1380137609.git.joe@perches.com>
	 <20130926.134408.91633054642517467.davem@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-26 at 13:44 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Wed, 25 Sep 2013 12:37:18 -0700
[]
> Pulled, thanks Joe.
> That should be about it for networking right?

Yes for drivers/net/...

There are some more files like:

include/linux/etherdevice.h
include/linux/inetdevice.h
include/linux/net.h
include/linux/netdevice.h
include/linux/skbuff.h

and some netfilter ones:

include/linux/netfilter*.h
include/linux/netfilter/...

and maybe a few others like:

include/linux/atmdev.h
include/linux/fddidevice.h

that I was planning on converting then submitting.

Want those in one more pull request or
maybe individually?

