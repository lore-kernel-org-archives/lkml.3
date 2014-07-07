Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaGGTcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:32:45 -0400
Received: from ns.pmeerw.net ([87.118.82.44]:57758 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaGGTco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:32:44 -0400
Date: Mon, 7 Jul 2014 21:32:39 +0200 (CEST)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Jonathan Cameron <jic23@kernel.org>
cc: Josef Gajdusek <atx@atx.name>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging:iio:hmc5843: Added regmap support
In-Reply-To: <8e31f2b8-25ed-450e-9b70-f9338f8f3c4b@email.android.com>
Message-ID: <alpine.DEB.2.01.1407072131050.23477@pmeerw.net>
References: <20140707185013.GA10383@dashie> <8e31f2b8-25ed-450e-9b70-f9338f8f3c4b@email.android.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > This patch changes hmc5843.c to use regmap. This provides
> >transparent caching
> >> > to the code as well as abstraction necessary to add support for
> >SPI-based
> >> > hmc5983.
> >> >
> >> > Signed-off-by: Josef Gajdusek <atx@atx.name>
> >> Hi Josef,
> >> 
> >> A few little bits and pieces inline.
> >> Peter, could you also take a look at this series?

I might manage to test the proposed code on a hmc5883l, probably until the 
weekend; otherwise patches look good

> >strange, I remember this causing issues. Now I am unable to
> >reproduce them so it was probably something else. Do you want me to
> >resend or can you apply without these lines swapped?
> 
> I am feeling lazy plus might not get to this until Saturday so resend.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
