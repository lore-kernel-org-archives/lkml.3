Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3AVQxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:53:39 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56422 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3AVQxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:53:34 -0500
Date: Tue, 22 Jan 2013 08:53:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Clark <rob@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org
Subject: Re: [PATCH 15/15] staging/omapdrm: don't build on multiplatform
Message-ID: <20130122165330.GA28152@kroah.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-16-git-send-email-arnd@arndb.de>
 <50FD7A5F.9020702@ti.com>
 <201301211741.11875.arnd@arndb.de>
 <50FD8B63.1060506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD8B63.1060506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 12:39:31PM -0600, Rob Clark wrote:
> On 01/21/2013 11:41 AM, Arnd Bergmann wrote:
> >On Monday 21 January 2013, Rob Clark wrote:
> >>Are you sure OMAP2_DSS requires ARCH_OMAP2PLUS?  I don't see this, and
> >>it at least used to not depend on ARCH_OMAP2PLUS.  If it does now, I
> >>think the correct fix would be to remove the dependency in OMAP2_DSS.  I
> >>don't think removing ARCH_MULTIPLATFORM support in omapdrm is the
> >>correct solution.
> >At least it says so in drivers/video/omap2/Kconfig, which contains
> >
> >if ARCH_OMAP2PLUS
> >source drivers/video/omap2/dss/Kconfig
> >endif
> 
> ahh, ok, I see.. the if ARCH_OMAP2PLUS bit looks like it came in
> recently (770b6cb)
> 
> what about changing this to 'if ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM'?

That's what Arnd's patch did.

totally confused,

greg k-h
