Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935895Ab3BTUZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:25:23 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:59300 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935026Ab3BTUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:25:20 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuA+AKowJVFV5qjOPGdsb2JhbABFhWC6f4EBFwMBAQEBODSCHwEBBTocEwEPEAgDGAklDwUNGAoaE4gAAxMItnANiVYEFYwiewmBUweCX2EDlFGBWoYChUWIHYFo
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="283970013"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:26:42 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] HID: multitouch: Copyright and note on regression
 tests
Message-ID: <20130220202642.GB1413@polaris.bitmath.org>
References: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
 <1360334256-22127-8-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360334256-22127-8-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:37:36PM +0100, Benjamin Tissoires wrote:
> This reflects my new company and officialize the regression tests I'm
> conducting between each change.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 184ac0a..3af9efdd 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -2,8 +2,9 @@
>   *  HID driver for multitouch panels
>   *
>   *  Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
> - *  Copyright (c) 2010-2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
> + *  Copyright (c) 2010-2013 Benjamin Tissoires <benjamin.tissoires@gmail.com>
>   *  Copyright (c) 2010-2012 Ecole Nationale de l'Aviation Civile, France
> + *  Copyright (c) 2012-2013 Red Hat, Inc
>   *
>   *  This code is partly based on hid-egalax.c:
>   *
> @@ -26,6 +27,17 @@
>   * any later version.
>   */
>  
> +/*
> + * This driver is regularly tested thanks to the tool hid-test[1].
> + * This tool relies on hid-replay[2] and a database of hid devices[3].
> + * Please run these regression tests before patching this module so that
> + * your patch won't break existing known devices.
> + *
> + * [1] https://github.com/bentiss/hid-test
> + * [2] https://github.com/bentiss/hid-replay
> + * [3] https://github.com/bentiss/hid-devices
> + */
> +
>  #include <linux/device.h>
>  #include <linux/hid.h>
>  #include <linux/module.h>
> -- 
> 1.8.1
> 

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
