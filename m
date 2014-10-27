Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaJ0SEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:04:00 -0400
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:58440 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752587AbaJ0SDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:03:54 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2551:2553:2559:2562:2828:2914:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:5007:6261:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan19_4b0e8bce230d
X-Filterd-Recvd-Size: 1952
Message-ID: <1414433031.18896.2.camel@perches.com>
Subject: Re: [PATCH 03/11] aiptek: Fix probable mask then right shift defects
From: Joe Perches <joe@perches.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Mon, 27 Oct 2014 11:03:51 -0700
In-Reply-To: <3320721.qubDk7TkeJ@dtor-glaptop>
References: <cover.1414387334.git.joe@perches.com>
	 <20141027144411.GA7594@dtor-ws> <1414432614.18896.1.camel@perches.com>
	 <3320721.qubDk7TkeJ@dtor-glaptop>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 11:01 -0700, Dmitry Torokhov wrote:
> On Monday, October 27, 2014 10:56:54 AM Joe Perches wrote:
> > On Mon, 2014-10-27 at 07:44 -0700, Dmitry Torokhov wrote:
> > > On Sun, Oct 26, 2014 at 10:24:59PM -0700, Joe Perches wrote:
> > > > Precedence of & and >> is not the same and is not left to right.
> > > > shift has higher precedence and should be done after the mask.
> > > 
> > > Looking at the protocol description the current code is exactly right.
> > > We want to "move" button bits first as in packet type 1 they are in a
> > > different place than in other packets.
> > > 
> > > I'll take a patch that adds parenthesis around shifts to make clear it
> > > is intended.
> > 
> > I think it's more sensible to do the shift first to a
> > temporary then direct comparisons.
[]
> Unless you have the device I'd rather kept the changes (which are mostly
> cosmetic in nature and do not fix any bugs) to a minimum.

I don't have the device.
I think you should do what you think appropriate.

cheers, Joe

