Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaGPWqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:46:19 -0400
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:46617 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754317AbaGPWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:46:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 30,2,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3871:3873:3874:4250:4321:5007:6119:7652:7903:10010:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: light70_703d0086d964d
X-Filterd-Recvd-Size: 1628
Message-ID: <1405550769.6381.17.camel@joe-AO725>
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Michalis Pappas <mpappas@fastmail.fm>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 Jul 2014 15:46:09 -0700
In-Reply-To: <20140716221034.GB716@kroah.com>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
	 <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
	 <20140709185142.GA13271@kroah.com> <53C6E332.2070301@fastmail.fm>
	 <20140716205024.GA11078@kroah.com> <53C6F69A.5070108@fastmail.fm>
	 <20140716221034.GB716@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-16 at 15:10 -0700, Greg KH wrote:
> On Wed, Jul 16, 2014 at 11:03:06PM +0100, Michalis Pappas wrote:
[]
> > Ok, I agree on the ifdef stuff. My question was regarding your
> > suggestion above to replace print_hex_debug() with dev_dbg()
> 
> You want the device name/id/label to show up as well, that is why you
> should use the dev_dbg() version, print_hex_dump() does not take a
> struct device *, so the user has no idea what device this data was
> coming from.

But Michalis could alway add something like:
	dev_hex_dump()
and
	dev_dbg_hex_dump()


