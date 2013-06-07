Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FGKW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 06:22:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3FGKW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 06:22:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Fri, 07 Jun 2013 12:22:19 +0200
Message-ID: <2386569.59VQ9D5dv5@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
References: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:knWgGoCNOm4W/gF4Brg6g15xQeN9Od2SW7SwlN+SSJb
 xv7Ngzbk4RIANcnKwHfFkghyvts7q5oTKSlUZovkn8l8x+ePLr
 bDSYPs6zRy9+Cnga5xHTwFCrxZYzKCdsnvtaw/jbKCavzzHqO1
 3fvlw9ytpI24XTPWjxCl+0CIndV1+78p5xNn4VpxKuCWA1OUUj
 0afeA/Q9BdMJRDbsfd1tqrLTdBVQfBAjL4VCuEa82hDBHzK4Yu
 FkAn4534x8jlRLcRMTFI6yANTFLGpjMpFAxG+6DWlz+cXo1Hqz
 TMcVW9j3GcL5bUvNxhh/cU9Z+H8FGA3Y8slOnJbbDlJeWLrlpT
 bI1YZ/QwWIJQgBIctNDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 June 2013 10:39:20 Jingoo Han wrote:
> Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
> build warning when CONFIG_PM_SLEEP is not selected. This is because
> sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
> the CONFIG_PM_SLEEP is enabled.
> 
> drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
> drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

I forgot:

Acked-by: Arnd Bergmann <arnd@arndb.de>
