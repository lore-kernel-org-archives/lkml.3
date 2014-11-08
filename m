Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaKHSqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:46:50 -0500
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:58523 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752395AbaKHSqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:46:49 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:857:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3351:3622:3870:3876:4321:4385:4388:4395:5007:6119:6261:6742:10004:10400:10848:11232:11657:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fly84_3af62a5988605
X-Filterd-Recvd-Size: 2391
Message-ID: <1415472403.23530.28.camel@perches.com>
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
Date: Sat, 08 Nov 2014 10:46:43 -0800
In-Reply-To: <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
References: <1415471865-1893-1-git-send-email-oded.gabbay@amd.com>
	 <1415471865-1893-7-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-11-08 at 20:37 +0200, Oded Gabbay wrote:
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -610,6 +610,16 @@ F:	drivers/crypto/geode*
>  F:	drivers/video/fbdev/geode/
>  F:	arch/x86/include/asm/geode.h
>  
> +AMD KFD (radeon extension)
> +M:	Oded Gabbay <oded.gabbay@amd.com>
> +L:	dri-devel@lists.freedesktop.org
> +T:	git git://people.freedesktop.org/~gabbayo/linux.git
> +S:	Supported
> +F:	drivers/gpu/drm/radeon/amdkfd/*
> +F:	drivers/gpu/drm/radeon/radeon_kfd.c
> +F:	drivers/gpu/drm/radeon/radeon_kfd.h
> +F:	include/linux/uapi/linux/kfd_ioctl.h

include/uapi/linux/kfd_ioctl.h

> +
>  AMD IOMMU (AMD-VI)
>  M:	Joerg Roedel <joro@8bytes.org>
>  L:	iommu@lists.linux-foundation.org

Please keep MAINTAINERS in alphabetical order too.
Move this new AMD KFD section after AMD IOMMU.

