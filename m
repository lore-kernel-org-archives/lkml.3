Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161486Ab3DEMat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:30:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51898 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161233Ab3DEMar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 08:30:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH V5 0/4] cpufreq: exynos5440: support for cpufreq driver
Date: Fri, 05 Apr 2013 14:38:26 +0200
Message-ID: <2949363.nNl2A6XIoS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 28, 2013 01:35:18 PM Amit Daniel Kachhap wrote:
> Submitting the V5 version of exynos5440 cpufreq driver. This patchset addresses
> all the coding and design concerns raised especially by Viresh.
> 
> Changes in V5:
> * Removed the unnecessary DT look up entry from mach-exynos5-dt.c.
> * Fixed all coding and comments issue raised by Viresh.
> 
> Changes in V4:
> * Added dev_err logs instead of pr_err.
> * Used the devm_ioremap_resource API.
> * Implemented several coding guidelines and minor error comments from Sylwester,
>   Russell and Viresh.
> 
> Changes in V3:
> * Converted the driver to probe based as suggested by Viresh. This is also
>   beneficial for multiplatform kernel.
> * Other coding guidelines related changes.
> * Moved the DT node outside cpu0 node as the driver is now a platform
>   driver.
> 
> Changes in V2:
> * Added OPP library support to parse DT parameters.
> * Removed a hack to handle interrupts in bootup.
> * Implemented other review comments from Viresh and Inder.
> 
> All these patches are dependent on Thomas Abraham common clock patches.
> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg15860.html)
> This whole patch series is based on 3.9-rc4.
> 
> Amit Daniel Kachhap (4):
>   cpufreq: exynos: Add cpufreq driver for exynos5440
>   cpufreq: exynos: Remove error return even if no soc is found
>   arm: exynos: Enable OPP library support for exynos5440
>   arm: dts: Add cpufreq controller node for Exynos5440 SoC
> 
>  .../bindings/cpufreq/cpufreq-exynos5440.txt        |   28 ++
>  arch/arm/boot/dts/exynos5440.dtsi                  |   12 +
>  arch/arm/mach-exynos/Kconfig                       |    2 +
>  drivers/cpufreq/Kconfig.arm                        |    9 +
>  drivers/cpufreq/Makefile                           |    1 +
>  drivers/cpufreq/exynos-cpufreq.c                   |    2 +-
>  drivers/cpufreq/exynos5440-cpufreq.c               |  474 ++++++++++++++++++++
>  7 files changed, 527 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/cpufreq/cpufreq-exynos5440.txt
>  create mode 100644 drivers/cpufreq/exynos5440-cpufreq.c

Is this for me or the Samsung tree?

If it's for me, I need ACKs from the Samsung tree maintainers.  Also, please
address the Viresh's comments.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
