Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaKHUy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 15:54:28 -0500
Received: from smtprelay0242.hostedemail.com ([216.40.44.242]:35714 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751561AbaKHUy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 15:54:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3874:4321:4388:5007:6261:6742:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13161:13229:13311:13357:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shake64_9335368dcd3a
X-Filterd-Recvd-Size: 2005
Message-ID: <1415480061.23530.33.camel@perches.com>
Subject: Re: [PATCH v5 06/24] Update MAINTAINERS and CREDITS files with
 amdkfd info
From: Joe Perches <joe@perches.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, Jingoo Han <jg1.han@samsung.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        David Rientjes <rientjes@google.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sebastian Reichel <sre@debian.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Antti Palosaari <crope@iki.fi>
Date: Sat, 08 Nov 2014 12:54:21 -0800
In-Reply-To: <545E67F4.4000706@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
	 <1415472403.23530.28.camel@perches.com> <545E67F4.4000706@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 20:59 +0200, Oded Gabbay wrote:
> I also noticed I forgot to modify drivers/gpu/drm/radeon/amdkfd/* to
> drivers/gpu/drm/amd/amdkfd/*

That should probably just be drivers/gpu/drm/adm/amdkfd/

The trailing star means if there are subdirectories, do not
match them, just match the files at that directory level.

A trailing slash matches all files and subdirectories.


