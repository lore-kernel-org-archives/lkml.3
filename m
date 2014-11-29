Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaK2NkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 08:40:24 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:56166 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaK2NkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 08:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <1417268073-7394-1-git-send-email-anjanasasindran123@gmail.com>
References: <1417268073-7394-1-git-send-email-anjanasasindran123@gmail.com>
Date: Sat, 29 Nov 2014 14:40:21 +0100
Message-ID: <CAAfyv34iJjgp3XjDGa0zKWEb7Ud9uq2X3kAk4Jb+tQe7FFFZdw@mail.gmail.com>
Subject: Re: [PATCH] staging:drivers:staging:ft1000:ft1000_pcmcia:ft1000_hw.c:Added
 a blank line after declaration
From: Belisko Marek <marek.belisko@gmail.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anjana,

please update subject to something like staging: ft1000: ....

Marek


On Sat, Nov 29, 2014 at 2:34 PM, Anjana Sasindran
<anjanasasindran123@gmail.com> wrote:
> This patch fix the checkpatch.pl warning
>
> WARNING: Missing a blank line after declaration
>
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> index 11dbe36..d5475b7 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> @@ -2042,6 +2042,7 @@ static void ft1000_get_drvinfo(struct net_device *dev,
>  static u32 ft1000_get_link(struct net_device *dev)
>  {
>         struct ft1000_info *info;
> +
>         info = netdev_priv(dev);
>         return info->mediastate;
>  }
> --
> 1.9.1
>



-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
