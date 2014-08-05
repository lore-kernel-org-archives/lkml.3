Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaHEEU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:20:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43580 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbaHEEU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:20:28 -0400
Date: Tue, 5 Aug 2014 05:20:25 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Wood <thomas.wood@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        YoungJun Cho <yj44.cho@samsung.com>, Inki Dae <daeinki@gmail.com>,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: Re: linux-next: build failures after merge of the drm tree
In-Reply-To: <20140805130926.4e8c8fe5@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1408050519270.22643@skynet.skynet.ie>
References: <20140805130926.4e8c8fe5@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hi Dave,
> 
> After merging the drm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "drm_sysfs_connector_remove" [drivers/gpu/drm/i2c/tda998x.ko] undefined!
> ERROR: "drm_sysfs_connector_add" [drivers/gpu/drm/i2c/tda998x.ko] undefined!
> 

I've fixed this, caught it myself a few mins after push,

The other I'm not sure about, I'll hope the exynos guys know what is going 
on.

Thanks,
Dave.
