Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaFFPpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:45:23 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:56002 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692AbaFFPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:45:22 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3350:3622:3865:3866:3871:3872:3873:3874:4321:5007:6119:7652:7903:7904:8603:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: talk49_4b9f473800d1b
X-Filterd-Recvd-Size: 1636
Message-ID: <1402069518.12882.5.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
From: Joe Perches <joe@perches.com>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Date: Fri, 06 Jun 2014 08:45:18 -0700
In-Reply-To: <804857E1F29AAC47BF68C404FC60A18465623059@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
	 <1402018556.3038.2.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
	 <1402068405.12513.5.camel@joe-AO725> <1402068842.12513.7.camel@joe-AO725>
	 <804857E1F29AAC47BF68C404FC60A18465623059@ORSMSX105.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 15:35 +0000, Allan, Bruce W wrote:
> > 	Message size exceeding 100 000 characters causes blocking.
> > 
> > But I believe that info is out of date.
> > 
> If it is out of date, can you explain how/why we got stung by it?

Dunno.

Too many recipients maybe?

cc'ing more than 20 or so people can run up against
that 1024 total byte header limit.

Maybe send me a copy of the original rejected posting?


