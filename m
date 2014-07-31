Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaGaTTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:19:43 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:34045 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaGaTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:19:41 -0400
Message-ID: <53DA96C7.30009@gmail.com>
Date: Thu, 31 Jul 2014 21:19:35 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 3/4] ARM: dts: Clean up exynos5250-snow
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-4-git-send-email-afaerber@suse.de>
In-Reply-To: <1406822910-6255-4-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas,

Please see my comments inline.

On 31.07.2014 18:08, Andreas Färber wrote:
> Use the new style of referencing inherited nodes and use symbolic names.
> 
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Andreas Färber <afaerber@suse.de>

[snip]

> -
>  	usb@12110000 {
> -		samsung,vbus-gpio = <&gpx1 1 0>;
> +		samsung,vbus-gpio = <&gpx1 1 GPIO_ACTIVE_HIGH>;
>  	};

This is a higher level node being overridden, so it should be specified
using references too.

>  
>  	fixed-rate-clocks {
> @@ -287,7 +206,7 @@
>  	};
>  
>  	hdmi {

Ditto.

Best regards,
Tomasz
