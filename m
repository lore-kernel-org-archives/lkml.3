Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3F1Sch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:32:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54327 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab3F1Scg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:32:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] minor improvements for ACPI dock and acpiphp drivers
Date: Fri, 28 Jun 2013 20:42:05 +0200
Message-ID: <12502713.xXzhItWZWA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 29, 2013 12:24:33 AM Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> This is an following up patchset of "[PATCH 0/3] ACPI / dock / PCI: Fix
> problems with dock and PCI hotplug" with minor code cleanups and
> refinements. It applies to
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
> 
> Due to hardware resource limitation, I have only done compilation and
> boot tests.
> 
> V2->V3:
>     The first four patches are the same as previous version and rework
>     all other patches according to review comments.
> 
> Jiang Liu (10):
>   ACPI, DOCK: avoid initializing acpi_dock_notifier_list multiple times
>   ACPI, DOCK: kill redundant spin lock in dock station object
>   ACPI, DOCK: mark initialization functions with __init
>   ACPI, DOCK: simplify implementation of dock_create_acpi_device()
>   ACPI: introduce helper function acpi_has_method()
>   ACPI: introduce helper function acpi_execute_simple_method()
>   ACPI: introduce two helper functions to simplify code
>   ACPI: change acpi_[bay|dock]_match() in scan.c as global functions
>   ACPI: simplify dock driver with new helper functions
>   ACPI: simplify acpiphp driver with new helper functions
> 
>  drivers/acpi/battery.c             |  19 +---
>  drivers/acpi/bus.c                 |   6 +-
>  drivers/acpi/dock.c                | 152 ++++-------------------------
>  drivers/acpi/ec.c                  |   4 +-
>  drivers/acpi/power.c               |   4 +-
>  drivers/acpi/processor_perflib.c   |  22 ++---
>  drivers/acpi/resource.c            |   4 +-
>  drivers/acpi/scan.c                | 189 +++++++++++++------------------------
>  drivers/acpi/sleep.c               |   7 +-
>  drivers/acpi/thermal.c             |  18 +---
>  drivers/acpi/utils.c               |  70 ++++++++++++++
>  drivers/acpi/video.c               |  56 ++++-------
>  drivers/acpi/video_detect.c        |  19 ++--
>  drivers/pci/hotplug/acpiphp_glue.c |  30 ++----
>  include/acpi/acpi_bus.h            |  10 ++
>  15 files changed, 218 insertions(+), 392 deletions(-)

Looks good, thanks!

I'll queue all 10 up for 3.12.

Rafael

