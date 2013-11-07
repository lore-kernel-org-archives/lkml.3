Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3KGID0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:03:26 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52024 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236Ab3KGIDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:03:14 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 03:03:14 EST
X-Sasl-enc: 7ctnQ+gt1xz49rPKHK2Woxudd75TW95TVn07551caENn 1383810920
Message-ID: <527B4746.90009@ladisch.de>
Date: Thu, 07 Nov 2013 08:54:46 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chen Gang <gang.chen@asianux.com>, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] include/uapi/sound/firewire.h: use "_UAPI"
 instead of "UAPI"
References: <527B0595.5030108@asianux.com>
In-Reply-To: <527B0595.5030108@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang wrote:
> When installing, "scripts/headers_install.sh" will strip guard macro'
> "_UAPI" to prevent from appearing it to users. And also, all another
> files which need uapi prefix always use "_UAPI", not "UAPI".
>
> So use "_UAPI" instead of "UAPI" on the guard macro, and also give a
> comment for "#endif".
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Acked-by: Clemens Ladisch <clemens@ladisch.de>

> ---
>  include/uapi/sound/firewire.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/uapi/sound/firewire.h b/include/uapi/sound/firewire.h
> index e86131c..59f5961 100644
> --- a/include/uapi/sound/firewire.h
> +++ b/include/uapi/sound/firewire.h
> @@ -1,5 +1,5 @@
> -#ifndef UAPI_SOUND_FIREWIRE_H_INCLUDED
> -#define UAPI_SOUND_FIREWIRE_H_INCLUDED
> +#ifndef _UAPI_SOUND_FIREWIRE_H_INCLUDED
> +#define _UAPI_SOUND_FIREWIRE_H_INCLUDED
>
>  #include <linux/ioctl.h>
>
> @@ -48,4 +48,4 @@ struct snd_firewire_get_info {
>   * Returns -EBUSY if the driver is already streaming.
>   */
>
> -#endif
> +#endif /* _UAPI_SOUND_FIREWIRE_H_INCLUDED */
