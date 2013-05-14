Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3ENAvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:51:15 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.205]:59144 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755649Ab3ENAvO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:51:14 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-9.tower-132.messagelabs.com!1368492672!14578579!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 May 2013 19:49:13 -0500
Subject: RE: [PATCH 2/2] misc: ep93xx_pwm: remove unnecessary
 platform_set_drvdata()
Thread-Topic: [PATCH 2/2] misc: ep93xx_pwm: remove unnecessary
 platform_set_drvdata()
Thread-Index: Ac5K5G+eyewmerWGShaB6B8jbdVETAFWFTGA
Message-ID: <ADE657CA350FB648AAC2C43247A983F0021D46AC8644@AUSP01VMBX24.collaborationhost.net>
References: <003801ce4ae4$830d02f0$892708d0$@samsung.com>
In-Reply-To: <003801ce4ae4$830d02f0$892708d0$@samsung.com>
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

On Monday, May 06, 2013 10:34 PM, Jingoo Han wrote:
> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/misc/ep93xx_pwm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

