Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161365Ab3BONPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:15:54 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:34521 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161258Ab3BONPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:15:53 -0500
Date: Fri, 15 Feb 2013 22:15:50 +0900
From: Simon Horman <horms@verge.net.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: Re: [PATCH 5/9] ARM: shmobile: mark mackerel sh_mmcif_device
 __maybe_unused
Message-ID: <20130215131550.GB27724@verge.net.au>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
 <1360880818-4071454-6-git-send-email-arnd@arndb.de>
 <20130214232426.GB30667@verge.net.au>
 <201302151255.06547.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201302151255.06547.arnd@arndb.de>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:55:06PM +0000, Arnd Bergmann wrote:
> On Thursday 14 February 2013, Simon Horman wrote:
> > On Thu, Feb 14, 2013 at 11:26:54PM +0100, Arnd Bergmann wrote:
> > > Patch eac036ef9e "ARM: shmobile: streamline mackerel SD and MMC devices"
> > > made the use of the sh_mmcif_device variable for mackarel optional,
> > > but the definition is always provided, causing a build warning.
> > > 
> > > arch/arm/mach-shmobile/board-mackerel.c:1120:31: warning: 'sh_mmcif_device'
> > > 	defined but not used [-Wunused-variable]
> > > 
> > > Marking the variable as __maybe_unused will do the right thing here.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > Cc: Simon Horman <horms+renesas@verge.net.au>
> > 
> > No objections here.
> > 
> > Acked-by: Simon Horman <horms+renesas@verge.net.au>
> 
> AFAICT, the change that caused this is in linux-next only through your
> heads/boards3 branch but not through arm-soc, so please apply my patch
> on your branch.

Sure, will do.
