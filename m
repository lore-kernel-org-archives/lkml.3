Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaKDP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:26:08 -0500
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:42099 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753301AbaKDP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:26:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3872:3873:4321:5007:6261:7903:8603:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twist20_6ede364f21d44
X-Filterd-Recvd-Size: 1489
Message-ID: <1415114760.24560.8.camel@perches.com>
Subject: Re: [PATCH] drm: Reduce code size of drm_err and DRM_DEBUG[_<FOO>]
 uses
From: Joe Perches <joe@perches.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Tue, 04 Nov 2014 07:26:00 -0800
In-Reply-To: <20141104085240.GA26941@phenom.ffwll.local>
References: <1415088226.24560.1.camel@perches.com>
	 <20141104085240.GA26941@phenom.ffwll.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 09:52 +0100, Daniel Vetter wrote:
> On Tue, Nov 04, 2014 at 12:03:46AM -0800, Joe Perches wrote:
> > Using %pf, __builtin_return_address(0) instead ofy 
> > "%s", __func__ reduces code size by eliminating
> > a function argument.
[]
> I have an earlier version from you of this patch already, and it's in
> linux-next. And this patch here lacks the changelog indicating what
> changed exactly. Can you please rebase on top of linux-next and improve
> the commit message?

I was working on another tree and didn't
see the first patch.  Ignore this please.


