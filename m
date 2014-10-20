Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaJTNfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:35:34 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50359 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaJTNfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:35:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>, monstr@monstr.eu,
        Russell King <linux@arm.linux.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 2/3] ARM: zynq: Enable generic allocator
Date: Mon, 20 Oct 2014 15:34:44 +0200
Message-ID: <3551714.krTvviG9Ue@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <e5623273ff5d730b54c0c7dfe306dfbb98d4f058.1413811526.git.michal.simek@xilinx.com>
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com> <e5623273ff5d730b54c0c7dfe306dfbb98d4f058.1413811526.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TBrKnlUUtzb1GBAkQRZtRwpkhk3W+X8GrtM1zDS+Dlx
 XlBN00ZyOvk2++ggslQOv7cIJ7hfdvTSEWlz1DG7eSecNqfJKE
 irg/rL13hJEdTZu5+lS79Mio7YLo7SHuLvo4senyRZ1OljluQ8
 oz7YJWulVQKuN9j2EVHzFYtxvewhP67XZHKAnPnNSHxS0ssAKw
 E74voV7UuW3CfFsvgtey+7JFJ9p/2U96xgi25tAcJQ5vvEtWCJ
 MUwP0n20OUbD1agJpa4vcjhk9v1SgCVwDJSYajTyoYmkTYrtNU
 bfkBTd0vyj5PYBeFHr94VHP2IcRusJm9Fnpcoff4fJy2jezYSK
 961iSdUcGCauRpDObBh4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 15:25:32 Michal Simek wrote:
> Enable generic allocator by default because it is used by OCMC driver.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>


Why doesn't the driver select this then?

	Arnd

> 
> diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
> index aaa5162c1509..d447adefd397 100644
> --- a/arch/arm/mach-zynq/Kconfig
> +++ b/arch/arm/mach-zynq/Kconfig
> @@ -5,6 +5,7 @@ config ARCH_ZYNQ
>         select ARM_GIC
>         select ARM_GLOBAL_TIMER if !CPU_FREQ
>         select CADENCE_TTC_TIMER
> +       select GENERIC_ALLOCATOR
>         select HAVE_ARM_SCU if SMP
>         select HAVE_ARM_TWD if SMP
>         select ICST
> 

