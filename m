Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab3FFJeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:34:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55726 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254Ab3FFJeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:34:18 -0400
Date: Thu, 6 Jun 2013 11:34:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH RFC v2 1/3] drivers/platform/x86: add cpu physically
 hotplug driver
Message-ID: <20130606093402.GA21272@pd.tnic>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com>
 <1370482835-764-2-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370482835-764-2-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:40:33AM +0800, liguang wrote:
> this driver will support cpu phyical add/removal automatically
> after online/offline. if cpu hotpluged, cpu will not
> online automatically, and for cpu offline, we try to
> do actually eject if allowed for cpu like
> "echo 1 > /sys/bus/acpi/devices/LNXCPU\:0X/eject"
> this "echo ..." is only present for recent kernel
> (sorry, can't figure out since when), for a little
> older kernel, there's not such approach AFAICS.
> 
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  drivers/platform/x86/Kconfig              |    8 ++++
>  drivers/platform/x86/Makefile             |    1 +
>  drivers/platform/x86/cpu_physic_hotplug.c |   60 +++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/platform/x86/cpu_physic_hotplug.c
> 
> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 8577261..39b2392 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -789,4 +789,12 @@ config PVPANIC
>  	  a paravirtualized device provided by QEMU; it lets a virtual machine
>  	  (guest) communicate panic events to the host.
>  
> +config QEMU_CPU_PHYSIC_HOTPLUG

This is hillarious: have you actually checked the dictionary on the
meaning of "physic"?

Yep, "laxative" because the kernel is constipated and can't hold its
CPUs anymore.

LOOOL :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
