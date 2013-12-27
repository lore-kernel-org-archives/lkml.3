Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3L0TIi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 14:08:38 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:57441 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3L0TIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 14:08:36 -0500
Date: Fri, 27 Dec 2013 20:08:31 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, oliver@neukum.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 6/6] r8152: support RTL8153
Message-ID: <20131227190831.GB29006@electric-eye.fr.zoreil.com>
References: <1388111649-1014-1-git-send-email-hayeswang@realtek.com>
 <1388111856-1065-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388111856-1065-1-git-send-email-hayeswang@realtek.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> index 4b1c0f3..3e09887 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -486,6 +486,7 @@ static const struct driver_info wwan_info = {
>  #define ZTE_VENDOR_ID		0x19D2
>  #define DELL_VENDOR_ID		0x413C
>  #define REALTEK_VENDOR_ID	0x0bda
> +#define VENDOR_ID_SAMSUNG	0x04e8

SAMSUNG_VENDOR_ID would be more consistent for this file.

-- 
Ueimor
