Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934457Ab3HJPiW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:38:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21642 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934414Ab3HJPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:38:20 -0400
X-IronPort-AV: E=Sophos;i="4.89,852,1367964000"; 
   d="scan'208";a="29005600"
Date: Sat, 10 Aug 2013 17:38:18 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE
 consistently
In-Reply-To: <1376148738.2083.17.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1308101735060.2076@localhost6.localdomain6>
References: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr> <1376148738.2083.17.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Aug 2013, Joe Perches wrote:

> On Sat, 2013-08-10 at 17:25 +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Because ARRAY_AND_SIZE changes the apparent arity of a function, if it is
> > used for one call to a given function, it would be better, if possible, to
> > use it for all of them.
> 
> I think it'd be better to remove ARRAY_AND_SIZE instead.

I can do that, if it is wanted, but there are over 200 uses, and I think 
it is a little bit positive in that it ensures that the array is passed 
along with its own size.

julia
