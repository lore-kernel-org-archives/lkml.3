Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3JMRj5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 13:39:57 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:48434 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754995Ab3JMRj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 13:39:56 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1536:1559:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3868:4321:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cart86_90a38c7cba95e
X-Filterd-Recvd-Size: 1157
Message-ID: <1381685992.8864.32.camel@joe-AO722>
Subject: Re: [PATCH 2/2] framebuffer: Use fb_<level>
From: Joe Perches <joe@perches.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 13 Oct 2013 10:39:52 -0700
In-Reply-To: <8e7d2ced3f358961988c2602b8d1dff673f569c0.1379640011.git.joe@perches.com>
References: <0926c7a34ac51c4cbb67debd0d883f41891e75d9.1379640011.git.joe@perches.com>
	 <8e7d2ced3f358961988c2602b8d1dff673f569c0.1379640011.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 18:35 -0700, Joe Perches wrote:
> Neaten and shorten the code using the new fb_<level> macros.
[]
>  59 files changed, 186 insertions(+), 224 deletions(-)

ping?

