Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3GVVRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:17:39 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:54374 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501Ab3GVVRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:17:37 -0400
Message-ID: <51EDA143.5050309@iki.fi>
Date: Tue, 23 Jul 2013 00:16:51 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/18] MAINTAINERS: Update it913x patterns
References: <cover.1374451988.git.joe@perches.com> <170209027bb96e454ee499671598aaca0f414df5.1374451989.git.joe@perches.com>
In-Reply-To: <170209027bb96e454ee499671598aaca0f414df5.1374451989.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.228
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 03:15 AM, Joe Perches wrote:
> commit d7104bffcfb ("[media] MAINTAINERS: add drivers/media/tuners/it913x*")
> used the incorrect file patterns.  Fix it.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Antti Palosaari <crope@iki.fi>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Antti Palosaari <crope@iki.fi>

PS. It wasn't that commit, but some later where driver was renamed, as 
it caused filename collision on media out-tree build.

> ---
>   MAINTAINERS | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aa5ccd0..7622b04 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4566,7 +4566,7 @@ W:	http://palosaari.fi/linux/
>   Q:	http://patchwork.linuxtv.org/project/linux-media/list/
>   T:	git git://linuxtv.org/anttip/media_tree.git
>   S:	Maintained
> -F:	drivers/media/tuners/it913x*
> +F:	drivers/media/tuners/tuner_it913x*
>
>   IVTV VIDEO4LINUX DRIVER
>   M:	Andy Walls <awalls@md.metrocast.net>
>


-- 
http://palosaari.fi/
