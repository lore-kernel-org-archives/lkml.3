Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964803AbaH0P1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:27:32 -0400
Received: from mblankhorst.nl ([141.105.120.124]:58668 "EHLO mblankhorst.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935535AbaH0P10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:27:26 -0400
Message-ID: <53FDF8DB.6050703@canonical.com>
Date: Wed, 27 Aug 2014 17:27:23 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>, linux-kernel@vger.kernel.org
CC: Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] ww-mutex: clarify help text for DEBUG_WW_MUTEX_SLOWPATH
References: <1409152766-31320-1-git-send-email-robdclark@gmail.com>
In-Reply-To: <1409152766-31320-1-git-send-email-robdclark@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

On 27-08-14 17:19, Rob Clark wrote:
> We really don't want distro's enabling this in their kernels.  Try and
> make that more clear.
> 
> Signed-off-by: Rob Clark <robdclark@gmail.com>
> ---
>  lib/Kconfig.debug | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 07c2832..1b233fc 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -892,6 +892,10 @@ config DEBUG_WW_MUTEX_SLOWPATH
>  	 the full mutex checks enabled with (CONFIG_PROVE_LOCKING) this
>  	 will test all possible w/w mutex interface abuse with the
>  	 exception of simply not acquiring all the required locks.
> +	 Note that this feature can introduce significant overhead, so
> +	 it really should not be enabled in a production or distro kernel,
> +	 even a debug kernel.  If you are a driver writer, enable it.  If
> +	 you are a distro, do not.
>  
>  config DEBUG_LOCK_ALLOC
>  	bool "Lock debugging: detect incorrect freeing of live locks"
> 
