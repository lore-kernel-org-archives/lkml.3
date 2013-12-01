Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LAWiZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 17:38:25 -0500
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:43673 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751063Ab3LAWiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 17:38:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3622:3876:3877:4321:5007:6114:6642:7652:8531:10004:10400:10471:10848:11232:11658:11914:12296:12517:12519:12679:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: body75_48ef5c2c2ee1d
X-Filterd-Recvd-Size: 2025
Message-ID: <1385937499.2664.21.camel@joe-AO722>
Subject: Re: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must
 be NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Date: Sun, 01 Dec 2013 14:38:19 -0800
In-Reply-To: <1385890523.4171.1.camel@jlt4.sipsolutions.net>
References: <528AEFB7.4060301@gmail.com>
	 <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com>
	 <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
	 <52957ADA.2080704@gmail.com>
	 (sfid-20131127_055211_558798_A7DF5684) <1385739487.8656.1.camel@jlt4.sipsolutions.net>
	 <5299D306.7070701@gmail.com>
	 (sfid-20131130_125901_519610_EDA4068E) <1385816013.4327.1.camel@jlt4.sipsolutions.net>
	 <5299ED38.4090509@gmail.com> <5299EFDD.6060405@gmail.com>
	 (sfid-20131130_150205_984535_068F14A9) <1385842134.6108.4.camel@jlt4.sipsolutions.net>
	 <1385843940.2664.4.camel@joe-AO722>
	 <1385890523.4171.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-01 at 10:35 +0100, Johannes Berg wrote:
> Good try, but no, now ap_sdata isn't even assigned. :)

Right.  Oh well.  There's no improving this without
significant rewrite.  Even then, there may not be much
overall improvement.

btw: Chen, I think fall-throughs are fine as long as
they are commented appropriately.


