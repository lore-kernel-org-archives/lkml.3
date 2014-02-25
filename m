Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750917AbaBYFX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:23:28 -0500
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:52685 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750707AbaBYFX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:23:26 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2733:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:4321:5007:7652:7903:9040:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jewel45_751b3618ed73f
X-Filterd-Recvd-Size: 1762
Message-ID: <1393305803.11020.119.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
From: Joe Perches <joe@perches.com>
To: Tom Rini <trini@ti.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 24 Feb 2014 21:23:23 -0800
In-Reply-To: <530BCB27.5040808@ti.com>
References: <1393274296-26179-1-git-send-email-trini@ti.com>
	 <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com>
	 <1393277304.11020.64.camel@joe-AO722> <530BBF10.6050601@ti.com>
	 <1393279377.11020.66.camel@joe-AO722> <530BC209.2000708@ti.com>
	 <1393279691.11020.69.camel@joe-AO722> <530BC5A4.4060803@ti.com>
	 <1393281098.11020.82.camel@joe-AO722> <530BCB27.5040808@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 17:43 -0500, Tom Rini wrote:
> My perl is quite limited, so however much effort you're interested in
> putting in here is greatly appreciated (even if it's pointing out
> something else already in the script to copy and modify).  We already
> ship a .checkpatch.conf so having to enable something by default is
> fine.  Thanks!

The U-Boot checkpatch is not the same as the current
linux version and would need updating.

Tell me a little more please about how often or possible
it would be to update the current linux version of
checkpatch to the version used in U-Boot.


