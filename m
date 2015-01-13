Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbbAMLmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:42:12 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:44077 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbAMLmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:42:10 -0500
Message-ID: <54B5048F.2070709@imgtec.com>
Date: Tue, 13 Jan 2015 11:42:07 +0000
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <alsa-devel@alsa-project.org>
CC: Vinod Koul <vinod.koul@intel.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALSA: compress_driver.h: include sound/core.h explicitly
References: <1418989110-10011-1-git-send-email-qais.yousef@imgtec.com>
In-Reply-To: <1418989110-10011-1-git-send-email-qais.yousef@imgtec.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

On 12/19/2014 11:38 AM, Qais Yousef wrote:
> Fixes the following compilation error:
>
>     include/sound/compress_driver.h: In function ‘snd_compr_drain_notify’:
>     include/sound/compress_driver.h:177:2: error: implicit declaration of function ‘snd_BUG_ON’ [-Werror=implicit-function-declaration]
>       if (snd_BUG_ON(!stream))
>
> snd_BUG_ON() is defined in sound/core.h but the file is not included explicitly,
> so include it.
>
> Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: linux-kernel@vger.kernel.org
>
> ---
>   include/sound/compress_driver.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/sound/compress_driver.h b/include/sound/compress_driver.h
> index 396e8f73670a..1e2531058b7e 100644
> --- a/include/sound/compress_driver.h
> +++ b/include/sound/compress_driver.h
> @@ -27,6 +27,7 @@
>   
>   #include <linux/types.h>
>   #include <linux/sched.h>
> +#include <sound/core.h>
>   #include <sound/compress_offload.h>
>   #include <sound/asound.h>
>   #include <sound/pcm.h>

