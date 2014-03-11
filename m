Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaCKLMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:12:39 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36736 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbaCKLMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:12:14 -0400
Message-ID: <531EEF7E.20107@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 16:41:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH v2] PM: Add missing "freeze" state
References: <1394536091-28881-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1394536091-28881-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031111-5490-0000-0000-00000524518F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 04:38 PM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> ---
> v2:
>   - Update comments for state_show() as suggested by Srivatsa S. Bhat
>     <srivatsa.bhat@linux.vnet.ibm.com>
> 
>  Documentation/ABI/testing/sysfs-power |    5 +++--
>  kernel/power/main.c                   |    4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
> index 205a73878441..64c9276e9421 100644
> --- a/Documentation/ABI/testing/sysfs-power
> +++ b/Documentation/ABI/testing/sysfs-power
> @@ -12,8 +12,9 @@ Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
>  Description:
>  		The /sys/power/state file controls the system power state.
>  		Reading from this file returns what states are supported,
> -		which is hard-coded to 'standby' (Power-On Suspend), 'mem'
> -		(Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
> +		which is hard-coded to 'freeze' (Low-Power Idle), 'standby'
> +		(Power-On Suspend), 'mem' (Suspend-to-RAM), and 'disk'
> +		(Suspend-to-Disk).
> 
>  		Writing to this file one of these strings causes the system to
>  		transition into that state. Please see the file
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index 1d1bf630e6e9..6271bc4073ef 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -282,8 +282,8 @@ struct kobject *power_kobj;
>   *	state - control system power state.
>   *
>   *	show() returns what states are supported, which is hard-coded to
> - *	'standby' (Power-On Suspend), 'mem' (Suspend-to-RAM), and
> - *	'disk' (Suspend-to-Disk).
> + *	'freeze' (Low-Power Idle), 'standby' (Power-On Suspend),
> + *	'mem' (Suspend-to-RAM), and 'disk' (Suspend-to-Disk).
>   *
>   *	store() accepts one of those strings, translates it into the
>   *	proper enumerated value, and initiates a suspend transition.
> 

