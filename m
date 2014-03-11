Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbaCKKVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:21:45 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41503 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaCKKVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:21:43 -0400
Message-ID: <531EE38D.7070105@linux.vnet.ibm.com>
Date: Tue, 11 Mar 2014 15:51:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH] PM: Add missing "freeze" state
References: <1394532270-4101-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1394532270-4101-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031110-5816-0000-0000-00000CC7F04C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2014 03:34 PM, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

While at it, can you also fix up the comment over the state_show()
function in kernel/power/main.c? It is also similarly outdated.

Regards,
Srivatsa S. Bhat

> ---
>  Documentation/ABI/testing/sysfs-power |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
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
> 

