Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3JGHFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 03:05:31 -0400
Received: from smtprelay0197.hostedemail.com ([216.40.44.197]:34534 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751745Ab3JGHFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 03:05:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:2693:2737:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3874:4321:5007:6119:7652:7903:10004:10400:10848:11026:11473:11658:11914:12296:12517:12519:12740:13069:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fuel44_4cf89f167a757
X-Filterd-Recvd-Size: 1288
Message-ID: <1381129527.2081.173.camel@joe-AO722>
Subject: Re: [PATCH TRIVIAL] net: correct typos in comments
From: Joe Perches <joe@perches.com>
To: ZHAO Gang <gamerh2o@gmail.com>
Cc: trivial@kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Date: Mon, 07 Oct 2013 00:05:27 -0700
In-Reply-To: <20131007065637.GA10624@will>
References: <20131007065637.GA10624@will>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 14:56 +0800, ZHAO Gang wrote:
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
[]
> @@ -378,7 +378,7 @@ typedef enum gro_result gro_result_t;
>   * RX_HANDLER_EXACT. The skb will only be delivered to protocol handlers that
>   * are registered on exact device (ptype->dev == skb->dev).
>   *
> - * If the rx_handler didn't changed skb->dev, but want the skb to be normally
> + * If the rx_handler didn't change skb->dev, but want the skb to be normally

wants


