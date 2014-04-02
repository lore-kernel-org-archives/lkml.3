Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbaDBXkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:40:43 -0400
Received: from smtprelay0252.hostedemail.com ([216.40.44.252]:59680 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932662AbaDBXkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:40:42 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3868:3870:3872:4321:5007:6119:7652:8957:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wall51_5cada1499d2e
X-Filterd-Recvd-Size: 1270
Message-ID: <1396482038.32040.19.camel@joe-AO722>
Subject: Re: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and
 strings style rule
From: Joe Perches <joe@perches.com>
To: Sherif <silentquote@gmail.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Apr 2014 16:40:38 -0700
In-Reply-To: <533C9F2A.9000102@gmail.com>
References: <1396480678-32036-1-git-send-email-shehabaldin.sherif@gmail.com>
	 <1396480892.32040.17.camel@joe-AO722> <533C9F2A.9000102@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 01:37 +0200, Sherif wrote:
> BTW regarding "Alignment should match open parenthesis" rule, It's 
> missing from Documentation/CodingStyle

It's "maintainer's preference" in at least
net/, drivers/net and drivers/staging.

Maybe it's true for drivers/usb too.

Greg?

