Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3CNOBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:01:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53121 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab3CNOBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:01:30 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 14 Mar 2013 07:01:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH 04/10] drivers: hwmon: use module_platform_driver_probe()
Message-ID: <20130314140130.GB16825@roeck-us.net>
References: <1363266691-15757-1-git-send-email-fabio.porcedda@gmail.com>
 <1363266691-15757-6-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363266691-15757-6-git-send-email-fabio.porcedda@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 02:11:25PM +0100, Fabio Porcedda wrote:
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/mc13783-adc.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
I have that one already queued for -next, submitted by Jingoo Han.

Thanks,
Guenter
