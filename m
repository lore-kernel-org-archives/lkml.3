Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab3IXEVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:21:12 -0400
Received: from smtprelay0240.hostedemail.com ([216.40.44.240]:60112 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750710Ab3IXEVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:21:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2915:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3872:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:7652:8957:9025:9040:10004:10400:10848:11232:11658:11914:12043:12517:12519:12679:12740:13069:13071:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: neck21_4457aa9c1b216
X-Filterd-Recvd-Size: 1325
Message-ID: <1379996467.3575.67.camel@joe-AO722>
Subject: Re: False positive in checkpatch
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Date: Mon, 23 Sep 2013 21:21:07 -0700
In-Reply-To: <20130923225949.GA26278@linux.vnet.ibm.com>
References: <20130923225949.GA26278@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-23 at 15:59 -0700, Paul E. McKenney wrote:
> Hello!
> 
> The checkpatch.pl script complains as follows:
> 
> ERROR: need consistent spacing around '*' (ctx:WxB)
> #57: FILE: include/linux/rcupdate.h:564:
> +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
> 
> Of course, the two uses of '*' are doing different things, so it should
> be OK for the spacing to be different.
> 
> Could you please fix this?
> 
> 							Thanx, Paul
> 

Hi Paul.

Try this patch: https://lkml.org/lkml/2013/9/2/428

Andy?  Can you verify this suggested patch please?

