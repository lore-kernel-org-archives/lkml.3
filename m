Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaE0Bck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:32:40 -0400
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:58359 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751575AbaE0Bcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:32:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1561:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3871:4321:4470:5007:7652:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skin29_340a8754ada5f
X-Filterd-Recvd-Size: 1212
Message-ID: <1401154356.519.45.camel@joe-AO725>
Subject: Re: [PATCH 5/4] get_maintainer: shut up perl critic
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 18:32:36 -0700
In-Reply-To: <20140526182207.34900c22@nehalam.linuxnetplumber.net>
References: <20140526203309.782169359@networkplumber.org>
	 <1401152449.519.41.camel@joe-AO725> <1401152635.519.42.camel@joe-AO725>
	 <20140526182207.34900c22@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 18:22 -0700, Stephen Hemminger wrote:
> Use the no critic annotation, with comment, to silence perl critic
> for places where the code is correct as is.

I think this uglifies the code and a more sensible solution
is not using perlcritic


