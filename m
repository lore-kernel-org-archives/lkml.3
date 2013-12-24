Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab3LXAVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 19:21:53 -0500
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:43615 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754099Ab3LXAVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 19:21:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3871:4321:5007:6119:6120:7652:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dolls92_4a1a17ae2a240
X-Filterd-Recvd-Size: 1240
Message-ID: <1387844508.22671.73.camel@joe-AO722>
Subject: Re: [RFC  v3] Add ff-memless-next
From: Joe Perches <joe@perches.com>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@prifuk.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        elias.vds@gmail.com
Date: Mon, 23 Dec 2013 16:21:48 -0800
In-Reply-To: <1494187.y8mYFDm1lA@geidi-prime>
References: <1494187.y8mYFDm1lA@geidi-prime>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 23:46 +0100, Michal Malý wrote:
> One case where uncombinable effects were mishandled was corrected. Rest of
> the changes are just coding style fixes.

trivia:

> diff --git a/drivers/input/ff-memless-next.c b/drivers/input/ff-memless-next.c
[]
> +static __always_inline s32 mlnx_calculate_x_force(const s32 level,
> +						  const u16 direction)

__always_inline is almost never warranted.
gcc generally does the right thing.


