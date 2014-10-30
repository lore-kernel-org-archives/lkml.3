Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759704AbaJ3NZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:25:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:55334 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759518AbaJ3NZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:25:53 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 3/3] rheap: move rheap.c from arch/powerpc/lib/ to lib/
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1414654264-2596-3-git-send-email-B45475@freescale.com>
Date: Thu, 30 Oct 2014 08:25:36 -0500
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        B07421@freescale.com, R63061@freescale.com
Content-Transfer-Encoding: 7bit
Message-Id: <F09BF3A4-A194-4120-ACA0-155077690131@kernel.crashing.org>
References: <1414654264-2596-1-git-send-email-B45475@freescale.com> <1414654264-2596-3-git-send-email-B45475@freescale.com>
To: Zhao Qiang <B45475@freescale.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30, 2014, at 2:31 AM, Zhao Qiang <B45475@freescale.com> wrote:

> qe need to use the rheap, so move it to public directory.
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
> arch/powerpc/Kconfig                                    | 3 ---
> arch/powerpc/include/asm/fsl_85xx_cache_sram.h          | 2 +-
> arch/powerpc/lib/Makefile                               | 2 --
> arch/powerpc/platforms/44x/Kconfig                      | 2 +-
> arch/powerpc/platforms/85xx/Kconfig                     | 2 +-
> arch/powerpc/platforms/Kconfig                          | 2 +-
> arch/powerpc/platforms/Kconfig.cputype                  | 2 +-
> arch/powerpc/sysdev/cpm1.c                              | 2 +-
> arch/powerpc/sysdev/cpm2.c                              | 2 +-
> arch/powerpc/sysdev/cpm_common.c                        | 2 +-
> arch/powerpc/sysdev/ppc4xx_ocm.c                        | 2 +-
> drivers/dma/bestcomm/Kconfig                            | 2 +-
> drivers/soc/fsl-qe/Kconfig                              | 2 +-
> drivers/soc/fsl-qe/qe.c                                 | 2 +-
> drivers/soc/fsl-qe/qe_common.c                          | 2 +-
> include/linux/fsl/bestcomm/sram.h                       | 2 +-
> {arch/powerpc/include/asm => include/linux/fsl}/rheap.h | 0
> lib/Kconfig                                             | 3 +++
> lib/Makefile                                            | 2 ++
> {arch/powerpc/lib => lib}/rheap.c                       | 2 +-
> 20 files changed, 20 insertions(+), 20 deletions(-)
> rename {arch/powerpc/include/asm => include/linux/fsl}/rheap.h (100%)
> rename {arch/powerpc/lib => lib}/rheap.c (99%)

NAK.  As I stated before you need to convert rheap users to lib/genalloc.c

- k
