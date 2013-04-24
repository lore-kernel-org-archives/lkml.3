Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3DXReW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:34:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55854 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab3DXReU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:34:20 -0400
Message-ID: <5178178E.5090605@ti.com>
Date: Wed, 24 Apr 2013 13:34:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: <amit.kachhap@linaro.org>, Zhang Rui <rui.zhang@intel.com>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 28/30] MAINTAINERS: update thermal entry by adding file
 cpu_cooling.h
References: <1366218743-20841-1-git-send-email-eduardo.valentin@ti.com> <1366218743-20841-29-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1366218743-20841-29-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui,

On 17-04-2013 13:12, Eduardo Valentin wrote:
> Add cpu_cooling.h to thermal entry in MAINTAINERS.
>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>

This one didnt get in. Does it need to go in a different tree?

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 05dd187..3e075dc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8011,6 +8011,7 @@ T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
>   S:      Supported
>   F:      drivers/thermal/
>   F:      include/linux/thermal.h
> +F:      include/linux/cpu_cooling.h
>
>   THINGM BLINK(1) USB RGB LED DRIVER
>   M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
>

