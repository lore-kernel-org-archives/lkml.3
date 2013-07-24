Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab3GXIHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:07:55 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39592 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3GXIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:07:15 -0400
Date: Wed, 24 Jul 2013 17:07:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] ARM: shmobile: r8a73a4: Remove ->init_machine() special
 case
Message-ID: <20130724080711.GM10027@verge.net.au>
References: <20130724035315.30631.28824.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724035315.30631.28824.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 12:53:15PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> No need to special case r8a73a4 ->init_machine(),
> so get rid of undesired cpufreq platform device
> from the generic long term r8a73a4 DT support code.
> 
> For short term support on APE6EVM the DT reference
> implementation already adds a "cpufreq-cpu0" platform
> device so that can be used for development.
> 
> Regarding more long term cpufreq support, perhaps
> it makes sense to adjust the cpufreq driver to check
> for DT information directly instead of using a
> platform device for software configuration and DT
> for hardware parameters.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/mach-shmobile/setup-r8a73a4.c |    6 ------
>  1 file changed, 6 deletions(-)

Thanks, I have queued this up for v3.12 in the cleanup2 branch.
