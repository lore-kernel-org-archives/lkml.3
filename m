Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaCSWf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:35:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57251 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754808AbaCSWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:35:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 1/2] PM: Correct whitespace errors in <linux/pm.h>
Date: Wed, 19 Mar 2014 23:50:56 +0100
Message-ID: <6636992.81rGEKjTqL@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395087971-31897-1-git-send-email-geert@linux-m68k.org>
References: <1395087971-31897-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 17, 2014 09:26:10 PM Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Why exactly are they errors?

> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>  include/linux/pm.h |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 8c6583a53a06..22ba7338d48c 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -379,7 +379,7 @@ const struct dev_pm_ops name = { \
>   *
>   * ON		No transition.
>   *
> - * FREEZE 	System is going to hibernate, call ->prepare() and ->freeze()
> + * FREEZE	System is going to hibernate, call ->prepare() and ->freeze()
>   *		for all devices.
>   *
>   * SUSPEND	System is going to suspend, call ->prepare() and ->suspend()
> @@ -423,7 +423,7 @@ const struct dev_pm_ops name = { \
>  
>  #define PM_EVENT_INVALID	(-1)
>  #define PM_EVENT_ON		0x0000
> -#define PM_EVENT_FREEZE 	0x0001
> +#define PM_EVENT_FREEZE		0x0001
>  #define PM_EVENT_SUSPEND	0x0002
>  #define PM_EVENT_HIBERNATE	0x0004
>  #define PM_EVENT_QUIESCE	0x0008
> @@ -612,11 +612,11 @@ struct dev_pm_domain {
>   * message is implicit:
>   *
>   * ON		Driver starts working again, responding to hardware events
> - * 		and software requests.  The hardware may have gone through
> - * 		a power-off reset, or it may have maintained state from the
> - * 		previous suspend() which the driver will rely on while
> - * 		resuming.  On most platforms, there are no restrictions on
> - * 		availability of resources like clocks during resume().
> + *		and software requests.  The hardware may have gone through
> + *		a power-off reset, or it may have maintained state from the
> + *		previous suspend() which the driver will rely on while
> + *		resuming.  On most platforms, there are no restrictions on
> + *		availability of resources like clocks during resume().
>   *
>   * Other transitions are triggered by messages sent using suspend().  All
>   * these transitions quiesce the driver, so that I/O queues are inactive.
> @@ -626,21 +626,21 @@ struct dev_pm_domain {
>   * differ according to the message:
>   *
>   * SUSPEND	Quiesce, enter a low power device state appropriate for
> - * 		the upcoming system state (such as PCI_D3hot), and enable
> - * 		wakeup events as appropriate.
> + *		the upcoming system state (such as PCI_D3hot), and enable
> + *		wakeup events as appropriate.
>   *
>   * HIBERNATE	Enter a low power device state appropriate for the hibernation
> - * 		state (eg. ACPI S4) and enable wakeup events as appropriate.
> + *		state (eg. ACPI S4) and enable wakeup events as appropriate.
>   *
>   * FREEZE	Quiesce operations so that a consistent image can be saved;
> - * 		but do NOT otherwise enter a low power device state, and do
> - * 		NOT emit system wakeup events.
> + *		but do NOT otherwise enter a low power device state, and do
> + *		NOT emit system wakeup events.
>   *
>   * PRETHAW	Quiesce as if for FREEZE; additionally, prepare for restoring
> - * 		the system from a snapshot taken after an earlier FREEZE.
> - * 		Some drivers will need to reset their hardware state instead
> - * 		of preserving it, to ensure that it's never mistaken for the
> - * 		state which that earlier snapshot had set up.
> + *		the system from a snapshot taken after an earlier FREEZE.
> + *		Some drivers will need to reset their hardware state instead
> + *		of preserving it, to ensure that it's never mistaken for the
> + *		state which that earlier snapshot had set up.
>   *
>   * A minimally power-aware driver treats all messages as SUSPEND, fully
>   * reinitializes its device during resume() -- whether or not it was reset
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
