Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871AbaCJPAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:00:08 -0400
Received: from smtprelay0014.hostedemail.com ([216.40.44.14]:36399 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753219AbaCJPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:00:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3872:3873:4321:4385:5007:7652:10004:10400:10848:11232:11658:11914:12114:12296:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sign78_578dd62e55136
X-Filterd-Recvd-Size: 1313
Message-ID: <1394463600.24244.0.camel@joe-AO722>
Subject: Re: [PATCH net-next 4/4] bonding: Convert memcpy(foo, bar,
 ETH_ALEN) to ether_addr_copy(foo, bar)
From: Joe Perches <joe@perches.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 08:00:00 -0700
In-Reply-To: <20140310094945.GA2864@minipsycho.orion>
References: <cover.1392508410.git.joe@perches.com>
	 <0022868482b6f5a6d723992e0802470771066cb1.1392508410.git.joe@perches.com>
	 <20140310094945.GA2864@minipsycho.orion>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 10:49 +0100, Jiri Pirko wrote:
> Many times, the original len ETH_ALEN was wrong. Bonding should work
> with other types than Ethernet as well.

It's been applied already.

Feel free to send patches to correct
whatever you think needs updating.


