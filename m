Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbbA2OPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 09:15:32 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46165 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbbA2OPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 09:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <1422538676-4615-4-git-send-email-javier.martinez@collabora.co.uk>
References: <1422538676-4615-1-git-send-email-javier.martinez@collabora.co.uk>
	<1422538676-4615-4-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 29 Jan 2015 19:45:28 +0530
Message-ID: <CAEUmHyYaqC4nz5CpteCaZT5CxfOFtK1vWnPZk6U-bowYCPezcA@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] misc: Add cros_ec_lpc driver for x86 devices
From: Varka Bhadram <varkabhadram@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2015 at 7:07 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>
> Chromebooks have an Embedded Controller (EC) that is used to
> implement various functions such as keyboard, power and battery.
>
> The AP can communicate with the EC through different bus types
> such as I2C, SPI or LPC.
>
> The cros_ec mfd driver is then composed of a core driver that
> register the sub-devices as mfd cells and provide a high level
> communication interface that is used by the rest of the kernel
> and bus specific interfaces modules.
>
> Each connection method then has its own driver, which register
> with the EC driver interface-agnostic interface.
>
> Currently, there are drivers to communicate with the EC over
> I2C and SPI and this driver adds support for LPC.
>
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>
> Changes since v3:
>  - Rename MYNAME to DRV_NAME
>  - Use devm_request_region() instead of request_region.
>    Suggested by Varka Bhadram.
>  - Remove release_region from cleanup handle logic by using devres API.
>    Suggested by Varka Bhadram.
>  - Use {dev,pr}_err() instead of {dev,pr}_warn() to log errors.
>

Addressed all of my comments... Thanks

Reviewed-by: Varka Bhadram <varkabhadram@gmail.com>

-- 
Regards,
Varka Bhadram.
