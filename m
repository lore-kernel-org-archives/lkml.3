Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBRAsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:48:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57694 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753943AbaBRAsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:48:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: lenb@kernel.org, rui.zhang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH 0/6] drivers/acpi: fix driver compile errors when CONFIG_PM_SLEEP is undefined
Date: Tue, 18 Feb 2014 02:03:39 +0100
Message-ID: <2205879.dV8tEujxdx@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1392250669.git.shuah.kh@samsung.com>
References: <cover.1392250669.git.shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 12, 2014 08:19:04 PM Shuah Khan wrote:
> The following acpi drivers fail with compile errors when CONFIG_PM_SLEEP
> is undefined.

I'm going to push all of these patches as fixes for 3.14.  Thanks!

> Shuah Khan (6):
>   drivers/acpi: fix ac driver compile error when CONFIG_PM_SLEEP is
>     undefined
>   drivers/acpi: fix battery driver compile error when CONFIG_PM_SLEEP is
>     undefined
>   drivers/acpi: fix button driver compile error when CONFIG_PM_SLEEP is
>     undefined
>   drivers/acpi: fix fan driver compile error when CONFIG_PM_SLEEP is
>     undefined
>   drivers/acpi: fix sbs driver compile error when CONFIG_PM_SLEEP is
>     undefined
>   drivers/acpi: fix thermal driver compile error when CONFIG_PM_SLEEP
>     is undefined
> 
>  drivers/acpi/ac.c      |    2 ++
>  drivers/acpi/battery.c |    2 ++
>  drivers/acpi/button.c  |    2 ++
>  drivers/acpi/fan.c     |    3 +++
>  drivers/acpi/sbs.c     |    2 ++
>  drivers/acpi/thermal.c |    2 ++
>  6 files changed, 13 insertions(+)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
