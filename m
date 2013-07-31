Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab3GaVFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:05:22 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.205]:27421 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab3GaVFU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:05:20 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-132.messagelabs.com!1375304711!10360326!10
X-Originating-IP: [216.166.12.98]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "kernel@savoirfairelinux.com" <kernel@savoirfairelinux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 31 Jul 2013 16:03:23 -0500
Subject: RE: [PATCH] gpio: (gpio-pca953x) move header to linux/platform_data/
Thread-Topic: [PATCH] gpio: (gpio-pca953x) move header to
 linux/platform_data/
Thread-Index: Ac6OMLdCIxPdjB8iS9mesyx+GQREiQAAHL1g
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021DAC5C27C5@AUSP01VMBX24.collaborationhost.net>
References: <1375304231-27281-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1375304231-27281-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 1:57 PM, Vivien Didelot wrote:
>
> This patch moves the pca953x.h header from include/linux/i2c to
> include/linux/platform_data and updates existing support accordingly.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---

<snip>

arch/arm/mach-ep93xx/vision_ep9307.c        |  2 +-

For the ep93xx change:

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Thanks
