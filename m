Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaAUXEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:04:12 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61706 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754677AbaAUXEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:04:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 45/73] acpi: delete non-required instances of include <linux/init.h>
Date: Wed, 22 Jan 2014 00:18:17 +0100
Message-ID: <2341064.aLl40BBp9X@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0-rc8+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1390339396-3479-46-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-46-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 21, 2014 04:22:48 PM Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/acpi/apei/apei-base.c       | 1 -
>  drivers/acpi/button.c               | 1 -
>  drivers/acpi/fan.c                  | 1 -
>  drivers/acpi/hed.c                  | 1 -
>  drivers/acpi/pci_irq.c              | 1 -
>  drivers/acpi/power.c                | 1 -
>  drivers/acpi/processor_perflib.c    | 1 -
>  drivers/acpi/processor_thermal.c    | 1 -
>  drivers/acpi/processor_throttling.c | 1 -
>  drivers/acpi/utils.c                | 1 -
>  10 files changed, 10 deletions(-)
> 
> diff --git a/drivers/acpi/apei/apei-base.c b/drivers/acpi/apei/apei-base.c
> index 8678dfe..a83e10f 100644
> --- a/drivers/acpi/apei/apei-base.c
> +++ b/drivers/acpi/apei/apei-base.c
> @@ -32,7 +32,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/acpi.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
> diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
> index 11c11f6..3e20dff 100644
> --- a/drivers/acpi/button.c
> +++ b/drivers/acpi/button.c
> @@ -25,7 +25,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
> diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
> index 1fb6290..78b5cc7 100644
> --- a/drivers/acpi/fan.c
> +++ b/drivers/acpi/fan.c
> @@ -25,7 +25,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
>  #include <asm/uaccess.h>
>  #include <linux/thermal.h>
> diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
> index aafe3ca..215777c 100644
> --- a/drivers/acpi/hed.c
> +++ b/drivers/acpi/hed.c
> @@ -23,7 +23,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/acpi.h>
>  #include <acpi/hed.h>
>  
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 52d45ea..7bd6a55 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -30,7 +30,6 @@
>  #include <linux/dmi.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/spinlock.h>
>  #include <linux/pm.h>
> diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> index ad7da68..9c909d4 100644
> --- a/drivers/acpi/power.c
> +++ b/drivers/acpi/power.c
> @@ -37,7 +37,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
> index ff90054..d2594ad 100644
> --- a/drivers/acpi/processor_perflib.c
> +++ b/drivers/acpi/processor_perflib.c
> @@ -28,7 +28,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/cpufreq.h>
>  #include <linux/slab.h>
>  #include <linux/acpi.h>
> diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
> index e003663..661c9d2 100644
> --- a/drivers/acpi/processor_thermal.c
> +++ b/drivers/acpi/processor_thermal.c
> @@ -28,7 +28,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/init.h>
>  #include <linux/cpufreq.h>
>  #include <linux/acpi.h>
>  #include <acpi/processor.h>
> diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
> index 28baa05..08be363 100644
> --- a/drivers/acpi/processor_throttling.c
> +++ b/drivers/acpi/processor_throttling.c
> @@ -29,7 +29,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <linux/init.h>
>  #include <linux/sched.h>
>  #include <linux/cpufreq.h>
>  #include <linux/acpi.h>
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index 0347a37..492cf4f 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -26,7 +26,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> -#include <linux/init.h>
>  #include <linux/types.h>
>  #include <linux/hardirq.h>
>  #include <linux/acpi.h>
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
