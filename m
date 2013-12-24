Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374Ab3LXBPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:15:49 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41534 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab3LXBPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:15:45 -0500
Message-ID: <52B8E038.2010208@lwfinger.net>
Date: Mon, 23 Dec 2013 19:15:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] staging: rtl8188eu: Drop print of build date/time
References: <cover.1387833347.git.josh@joshtriplett.org> <d50d2e14a689b41986fbfc27dc9312553ed60ebf.1387833347.git.josh@joshtriplett.org>
In-Reply-To: <d50d2e14a689b41986fbfc27dc9312553ed60ebf.1387833347.git.josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2013 03:55 PM, Josh Triplett wrote:
> The kernel already has this information, and individual drivers
> shouldn't duplicate that.  This also eliminates the use of __DATE__ and
> __TIME__, which make the build non-deterministic.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>   drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> index 7d14779..d44f606 100644
> --- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> +++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> @@ -865,7 +865,6 @@ static int __init rtw_drv_entry(void)
>   	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_entry\n"));
>
>   	DBG_88E(DRV_NAME " driver version=%s\n", DRIVERVERSION);
> -	DBG_88E("build time: %s %s\n", __DATE__, __TIME__);
>
>   	rtw_suspend_lock_init();

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
>

