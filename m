Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaGJWii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:38:38 -0400
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:45445 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750927AbaGJWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:38:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1566:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:3868:3870:3871:4321:4605:5007:6119:6120:7652:7901:10004:10400:10848:11232:11658:11914:12291:12296:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0
X-HE-Tag: fact59_85105648d604f
X-Filterd-Recvd-Size: 1554
Message-ID: <1405031913.2796.7.camel@joe-AO725>
Subject: Re: [PATCH 04/83] drm/radeon: Add radeon <--> kfd interface
From: Joe Perches <joe@perches.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Date: Thu, 10 Jul 2014 15:38:33 -0700
In-Reply-To: <1405029027-6085-3-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
	 <1405029027-6085-3-git-send-email-oded.gabbay@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 00:50 +0300, Oded Gabbay wrote:
> This patch adds the interface between the radeon driver and the kfd
> driver. The interface implementation is contained in
> radeon_kfd.c and radeon_kfd.h.
[]
>  include/linux/radeon_kfd.h          | 67 ++++++++++++++++++++++++++

Is there a good reason to put this file in include/linux?


