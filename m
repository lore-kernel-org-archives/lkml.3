Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3FXLva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:51:30 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:48982 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3FXLv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:51:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Rob Landley <rob@landley.net>, Rusty Russell <rusty@rustcorp.com.au>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2] Documentation / cpu hotplug: Rephrase the outdated description for MADT entries
Date: Mon, 24 Jun 2013 14:00:53 +0200
Message-ID: <2689985.7MvxW2GhJV@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371805758-2841-1-git-send-email-hanjun.guo@linaro.org>
References: <1371805758-2841-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 21, 2013 05:09:18 PM Hanjun Guo wrote:
> More than 256 entries in ACPI MADT is supported from ACPI 3.0, so the
> information should be updated.
> 
> -v2: Rephrase the information instead of simply removing it according
> to Rafael's advice.

Queued up for 3.11.

Thanks,
Rafael


> Suggested-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  Documentation/cpu-hotplug.txt |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
> index 9f40135..67f733d 100644
> --- a/Documentation/cpu-hotplug.txt
> +++ b/Documentation/cpu-hotplug.txt
> @@ -370,8 +370,10 @@ A: There is no clear spec defined way from ACPI that can give us that
>     CPUs in MADT as hotpluggable CPUS.  In the case there are no disabled CPUS
>     we assume 1/2 the number of CPUs currently present can be hotplugged.
>  
> -   Caveat: Today's ACPI MADT can only provide 256 entries since the apicid field
> -   in MADT is only 8 bits.
> +   Caveat: ACPI MADT can only provide 256 entries in systems with only ACPI 2.0c
> +   or earlier ACPI version supported, because the apicid field in MADT is only
> +   8 bits. From ACPI 3.0, this limitation was removed since the apicid field
> +   was extended to 32 bits with x2APIC introduced.
>  
>  User Space Notification
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
