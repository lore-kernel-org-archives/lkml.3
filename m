Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaEaW31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 18:29:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51072 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753352AbaEaW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 18:29:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Niv Yehezkel <executerx@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] power: fixed typo in comment
Date: Sun, 01 Jun 2014 00:46:36 +0200
Message-ID: <3171547.isM6f2dnGY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140531102601.GA11021@localhost.localdomain>
References: <20140531102601.GA11021@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 31, 2014 06:26:01 AM Niv Yehezkel wrote:
> fixed a trivial comment typo (s/mam/map) in kernel/power/swap.c.
> 
> Signed-off-by: Niv Yehezkel <executerx@gmail.com>

Applied, thanks!

> ---
>  kernel/power/swap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 8c9a481..aaa3261 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -567,7 +567,7 @@ static int lzo_compress_threadfn(void *data)
>  
>  /**
>   * save_image_lzo - Save the suspend image data compressed with LZO.
> - * @handle: Swap mam handle to use for saving the image.
> + * @handle: Swap map handle to use for saving the image.
>   * @snapshot: Image to read data from.
>   * @nr_to_write: Number of pages to save.
>   */
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
