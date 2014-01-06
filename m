Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaAFLJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:09:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50424 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752652AbaAFLJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:09:35 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: add ABI entry for intel_pstate
Date: Mon, 06 Jan 2014 12:23:21 +0100
Message-ID: <7285568.L7MucgKD21@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1388997077-25138-1-git-send-email-artagnon@gmail.com>
References: <1388997077-25138-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 06, 2014 02:01:17 PM Ramkumar Ramachandra wrote:
> Add a Documentation/ABI entry for
> /sys/devices/system/cpu/intel_pstate/max_perf_pct,
> /sys/devices/system/cpu/intel_pstate/min_perf_pct, and
> /sys/devices/system/cpu/intel_pstate/no_turbo.
> 
> Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Linux PM <linux-pm@vger.kernel.org>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-system-cpu | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 468e4d4..7080718 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -200,3 +200,18 @@ Description:	address and size of the percpu note.
>  		note of cpu#.
>  
>  		crash_notes_size: size of the note of cpu#.
> +
> +
> +What:		/sys/devices/system/cpu/intel_pstate/max_perf_pct
> +		/sys/devices/system/cpu/intel_pstate/min_perf_pct
> +		/sys/devices/system/cpu/intel_pstate/no_turbo

Well, can you please describe each of them separately?  Like what each of them
actually does?

> +Date:		February 2013
> +Contact:	linux-pm@vger.kernel.org
> +Description:	Parameters for the Intel P-state driver
> +
> +		Logic for selecting the current P-state in Intel
> +		Sandybridge+ processors. The three knobs control
> +		limits for the P-state that will be requested by the
> +		driver.
> +
> +		More details can be found in Documentation/cpu-freq/intel-pstate.txt

No, that's not enough.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
