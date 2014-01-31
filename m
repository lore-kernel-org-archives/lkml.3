Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaAaKl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:41:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38810 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaAaKlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:41:25 -0500
Date: Fri, 31 Jan 2014 11:41:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Barksdale <dbarksdale@uplogix.com>
cc: David Herrmann <dh.herrmann@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Oliver Neukum <oliver@neukum.org>,
        =?ISO-8859-15?Q?Jakub_K=E1kona?= <kjakub@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] HID: New hid-cp2112 driver
In-Reply-To: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
Message-ID: <alpine.LNX.2.00.1401311138400.27155@pobox.suse.cz>
References: <1391037975-26253-1-git-send-email-dbarksdale@uplogix.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014, David Barksdale wrote:

> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 34e2d39..246a233 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -175,6 +175,15 @@ config HID_PRODIKEYS
>  	  multimedia keyboard, but will lack support for the musical keyboard
>  	  and some additional multimedia keys.
>  
> +config HID_CP2112
> +	tristate "Silicon Labs CP2112 HID USB-to-SMBus Bridge support"
> +	depends on USB_HID

Dependency on I2C is necessary as well, isn't it?

Other than that, it looks good to me.

-- 
Jiri Kosina
SUSE Labs
