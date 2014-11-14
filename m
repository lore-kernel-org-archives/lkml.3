Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaKNFct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 00:32:49 -0500
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:53733 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751258AbaKNFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 00:32:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3870:3871:4321:5007:6261:7808:9121:10004:10400:10848:11026:11232:11233:11658:11914:12043:12262:12438:12517:12519:12555:12679:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cake17_181087e11f44a
X-Filterd-Recvd-Size: 1861
Message-ID: <1415943164.5912.4.camel@perches.com>
Subject: Re: [PATCH] carl9170: Convert byte_rev_table uses to bitrev8
From: Joe Perches <joe@perches.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'chunkeey@googlemail.com'" <chunkeey@googlemail.com>,
        "'linville@tuxdriver.com'" <linville@tuxdriver.com>,
        "'linux-wireless@vger.kernel.org'" <linux-wireless@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Nov 2014 21:32:44 -0800
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D1829D@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E010D1829D@CNBJMBX05.corpusers.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 13:16 +0800, Wang, Yalin wrote:
> Use the inline function instead of directly indexing the array.
> 
> This allows some architectures with hardware instructions for bit
> reversals to eliminate the array.

This one is already in -next

commit 7a1283d8f5298437a454ec477384dcd9f9f88bac
Author: Joe Perches <joe@perches.com>
Date:   Tue Oct 28 14:18:58 2014 -0700

    carl9170: Convert byte_rev_table uses to bitrev8
    
    Use the inline function instead of directly indexing the array.
    
    This allows some architectures with hardware instructions
    for bit reversals to eliminate the array.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


