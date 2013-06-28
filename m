Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3F1DdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 23:33:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52128 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565Ab3F1DdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 23:33:00 -0400
Date: Fri, 28 Jun 2013 04:33:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: linux-next: build warning after merge of the drm tree
In-Reply-To: <20130628133029.d8997882c3e83644e0665027@canb.auug.org.au>
Message-ID: <alpine.DEB.2.00.1306280432420.14351@skynet.skynet.ie>
References: <20130628133029.d8997882c3e83644e0665027@canb.auug.org.au>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> After merging the drm tree, today's linux-next builds (powerpc
> ppc64_defconfig and x86_64 allmodconfig) produced this warning:

Latest -next tree just drops that FB_OMAP2 dep completely.

too much hassle.

Thanks,
Dave.
