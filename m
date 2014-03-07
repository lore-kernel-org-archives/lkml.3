Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaCGJap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:30:45 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:42070 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751168AbaCGJam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:30:42 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3872:3873:4321:5007:6119:7652:8527:10007:10400:10848:11232:11658:11914:12050:12517:12519:12740:13019:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: ship54_5d11ac659992d
X-Filterd-Recvd-Size: 1617
Message-ID: <1394184637.16156.58.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: net and drivers/net: Warn on missing blank
 line after variable declaration
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com,
        devel@linuxdriverproject.org, David Miller <davem@davemloft.net>
Date: Fri, 07 Mar 2014 01:30:37 -0800
In-Reply-To: <20140307075247.GA29018@mwanda>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	 <1394104390-23477-1-git-send-email-kys@microsoft.com>
	 <20140306.142919.763823800315842610.davem@davemloft.net>
	 <1394148520.16156.8.camel@joe-AO722> <20140307075247.GA29018@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 10:54 +0300, Dan Carpenter wrote:
> How many warnings does this generate does this generate when you run it
> across the whole tree?

A lot.

Check back with me after the week or so
it'll take to run on this little netboook.

Try this with both patches applied if you want
to know yourself...

$ git ls-files | grep "\.[ch]$"| \
  xargs ./scripts/checkpatch.pl -f --strict --types=spacing --emacs --terse | \
  grep "Missing a blank"



