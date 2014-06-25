Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbaFYFAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:00:01 -0400
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:45063 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754205AbaFYFAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:00:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3873:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12114:12517:12519:12663:12740:13069:13161:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: field94_39df51df6c00b
X-Filterd-Recvd-Size: 1327
Message-ID: <1403672396.17451.3.camel@joe-AO725>
Subject: Re: [PATCH V2 08/22] amd: Use pci_zalloc_consistent
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Don Fry <pcnet32@frontier.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 24 Jun 2014 21:59:56 -0700
In-Reply-To: <53AA54BE.9030206@roeck-us.net>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
	 <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
	 <53AA54BE.9030206@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 21:49 -0700, Guenter Roeck wrote:
> On 06/23/2014 02:05 PM, Joe Perches wrote:
> > V2: Don Fry is an 80 column neatnik.
> And you are an 'align with (' neatnik, so guess the two of you are even :-)

Guilty.

The editor (emacs in my case) allows me to forget I am one though.


