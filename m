Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbbAKREK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 12:04:10 -0500
Received: from smtprelay0221.hostedemail.com ([216.40.44.221]:60602 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751077AbbAKREG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 12:04:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2693:2731:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3872:3873:4043:4321:5007:6261:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13215:13229:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: uncle90_7acad55f22726
X-Filterd-Recvd-Size: 1343
Message-ID: <1420995841.3690.4.camel@perches.com>
Subject: Re: [PATCH] staging: unisys: Convert direct LOGERR uses to pr_err
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        LKML <linux-kernel@vger.kernel.org>, sparmaintainer@unisys.com
Date: Sun, 11 Jan 2015 09:04:01 -0800
In-Reply-To: <20150111165708.GA27161@kroah.com>
References: <1420945742.16787.12.camel@perches.com>
	 <20150111041319.GB22334@kroah.com> <1420952121.32288.1.camel@perches.com>
	 <20150111052428.GC24038@kroah.com> <1420954353.32288.3.camel@perches.com>
	 <20150111165708.GA27161@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 08:57 -0800, Greg Kroah-Hartman wrote:
> It will need to be done to get the code merged out of staging, so it
> better happen...

Maybe the unisys folk will do something in the
order you want.  Good luck.


