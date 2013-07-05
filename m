Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab3GEB1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:27:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58922 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3GEB1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:27:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Fri, 05 Jul 2013 03:37:21 +0200
Message-ID: <1883101.ErAYOZUY8P@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130705112458.f7e8297da9ea551c9fca2cb5@canb.auug.org.au>
References: <20130705112458.f7e8297da9ea551c9fca2cb5@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 11:24:58 AM Stephen Rothwell wrote:
> Hi Rafael,

Hi,

> After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/gpu/drm/radeon/atombios_encoders.c: In function 'radeon_atom_backlight_init':
> drivers/gpu/drm/radeon/atombios_encoders.c:230:2: error: implicit declaration of function 'acpi_osi_version' [-Werror=implicit-function-declaration]
>   if (acpi_osi_version() >= ACPI_OSI_WIN_8)
>   ^
> drivers/gpu/drm/radeon/atombios_encoders.c:230:28: error: 'ACPI_OSI_WIN_8' undeclared (first use in this function)
>   if (acpi_osi_version() >= ACPI_OSI_WIN_8)
>                             ^
> drivers/gpu/drm/radeon/atombios_encoders.c:231:3: error: implicit declaration of function 'acpi_video_backlight_unregister' [-Werror=implicit-function-declaration]
>    acpi_video_backlight_unregister();
>    ^
> 
> Caused by commit 1823b2aeccce ("drm/radeon: don't provide ACPI backlight
> if firmware expects Windows 8").

Dropped that commit for now (along with the whole branch).

> 
> I have used the pm tree from next-20130704 for today.

Sorry for the trouble!

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
