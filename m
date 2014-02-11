Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaBKROM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:14:12 -0500
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:56540 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752916AbaBKROI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:14:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1960:2194:2199:2393:2559:2562:2741:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3874:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12043:12291:12347:12517:12519:12555:12683:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: watch40_7a436096f2b0d
X-Filterd-Recvd-Size: 1919
Message-ID: <1392138837.2511.2.camel@joe-AO722>
Subject: Re: [PATCH v3] ieee80211: Print human-readable disassoc/deauth
 reason codes
From: Joe Perches <joe@perches.com>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 09:13:57 -0800
In-Reply-To: <20140211163738.GA32043@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
	 <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com>
	 <1392082740.2507.49.camel@joe-AO722> <20140211163738.GA32043@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 10:37 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that in addition to the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.
[]
>  include/net/mac80211.h | 10 +++++++++
>  net/mac80211/main.c    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/mlme.c    | 12 +++++------
>  3 files changed, 73 insertions(+), 6 deletions(-)

Is there a reason why all of this this shouldn't
be a static function local to mlme.c?

Is this ever going to be used somewhere else?


