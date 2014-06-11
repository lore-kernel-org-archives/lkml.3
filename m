Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaFKIug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:50:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaFKIud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:50:33 -0400
Date: Wed, 11 Jun 2014 10:50:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Brian Norris <computersforpeace@gmail.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: drop remove Unicode non-breaking space from
 Kconfig
In-Reply-To: <1402436136-17918-1-git-send-email-computersforpeace@gmail.com>
Message-ID: <alpine.LNX.2.00.1406111050241.1321@pobox.suse.cz>
References: <1402436136-17918-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014, Brian Norris wrote:

> There is a UTF-8 non-breaking space character (0xc2 0xa0) after the "Y"
> in "Say Y here". This is probably not intentional. Replace it with a
> standard ASCII space (0x20).
> 
> If you can't see a difference here, I don't blame you :)
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linux-input@vger.kernel.org
> ---
>  drivers/hid/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 800c8b60f7a2..08c9693e6f83 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -785,7 +785,7 @@ config HID_XINMO
>  	depends on HID
>  	---help---
>  	Support for Xin-Mo devices that are not fully compliant with the HID
> -	standard. Currently only supports the Xin-Mo Dual Arcade. Say Y here
> +	standard. Currently only supports the Xin-Mo Dual Arcade. Say Y here
>  	if you have a Xin-Mo Dual Arcade controller.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
