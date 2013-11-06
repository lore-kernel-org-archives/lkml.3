Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3KFRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:55:57 -0500
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:55723 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754675Ab3KFRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:55:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3873:3874:4321:5007:6119:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custo
X-HE-Tag: page91_5060dfbd5101f
X-Filterd-Recvd-Size: 1929
Message-ID: <1383760556.7940.28.camel@joe-AO722>
Subject: Re: [PATCH] wcn36xx: Fix logging macro with unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx <wcn36xx@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ath5k-devel@venema.h4ckr.net,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>, ath10k@lists.infradead.org
Date: Wed, 06 Nov 2013 09:55:56 -0800
In-Reply-To: <CAFSJ42YQy96Sko8CuG9BGjHzTV7TkRp2=NVt036APxSKpPB=Ag@mail.gmail.com>
References: <1383684000.4387.42.camel@joe-AO722>
	 <CAFSJ42YQy96Sko8CuG9BGjHzTV7TkRp2=NVt036APxSKpPB=Ag@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-06 at 07:49 +0000, Eugene Krasnikov wrote:
> Hm... when it comes to semicolon the patch seems to be good. When it
> comes to dynamic debugging i think we should have a separate
> discussion about that.
> I personally like the whole idea about dynamic debug but if you want
> to change it i would suggest to have some kind of framework for all
> ath drivers(or maybe all wireless drivers). Because obviously you can
> find common code in every driver that defines it's own debug
> functions/debug levels and so on. Why not to make a framework with
> standard API/levels?

You need to bring that up with the Atheros folk.
I've tried.  The view seemed to be it was more
trouble than it was worth.



