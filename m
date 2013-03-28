Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3C1BkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 21:40:04 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33342 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755152Ab3C1BkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 21:40:02 -0400
Message-ID: <51539F01.2020401@marvell.com>
Date: Thu, 28 Mar 2013 09:38:09 +0800
From: Zhou Zhu <zzhu3@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrei Epure <epure.andrei@gmail.com>
CC: "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Lisa Du <cldu@marvell.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: mmp: removed reference preceded by free
References: <1364417318-26650-1-git-send-email-epure.andrei@gmail.com>
In-Reply-To: <1364417318-26650-1-git-send-email-epure.andrei@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 04:48 AM, Andrei Epure wrote:
> Patch found with coccinelle.
>
> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>   drivers/video/mmp/core.c |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/video/mmp/core.c b/drivers/video/mmp/core.c
> index 9ed8341..84de263 100644
> --- a/drivers/video/mmp/core.c
> +++ b/drivers/video/mmp/core.c
> @@ -252,7 +252,5 @@ void mmp_unregister_path(struct mmp_path *path)
>
>   	kfree(path);
>   	mutex_unlock(&disp_lock);
> -
> -	dev_info(path->dev, "de-register %s\n", path->name);
>   }
>   EXPORT_SYMBOL_GPL(mmp_unregister_path);
>
Acked-by: Zhou Zhu <zzhu3@marvell.com>
