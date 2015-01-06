Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbbAFO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:29:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbbAFO3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:29:04 -0500
Date: Tue, 6 Jan 2015 09:28:55 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial] HID: Spelling s/Keayboard/Keyboard/
Message-ID: <20150106142854.GA26291@mail.corp.redhat.com>
References: <1420531753-10668-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420531753-10668-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 06 2015 or thereabouts, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Good catch.

Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Cheers,
Benjamin

> ---
>  drivers/hid/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 230b6f887cd86e9b..303b295a5413d39b 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -388,7 +388,7 @@ config HID_LOGITECH_HIDPP
>  	Say Y if you want support for Logitech devices relying on the HID++
>  	specification. Such devices are the various Logitech Touchpads (T650,
>  	T651, TK820), some mice (Zone Touch mouse), or even keyboards (Solar
> -	Keayboard).
> +	Keyboard).
>  
>  config LOGITECH_FF
>  	bool "Logitech force feedback support"
> -- 
> 1.9.1
> 
