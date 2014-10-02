Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaJBHnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:43:08 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:36007 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaJBHnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:43:05 -0400
MIME-Version: 1.0
In-Reply-To: <1412225138-16158-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1412225138-16158-1-git-send-email-michael.opdenacker@free-electrons.com>
Date: Thu, 2 Oct 2014 09:43:04 +0200
Message-ID: <CAH6sp9Ozkhqa=CJa6YXUwoKHn68VvrsohZu099obGN01ZFCwmA@mail.gmail.com>
Subject: Re: [PATCH] [TRIVIAL] mod_devicetable.h: grammar fix in comment
From: Frans Klaver <fransklaver@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Jiri Kosina <trivial@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        johannes.thumshirn@men.de, joshc@codeaurora.org, dl9pf@gmx.de,
        behanw@converseincode.com, kheitke@codeaurora.org,
        ard.biesheuvel@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2014 at 6:45 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  include/linux/mod_devicetable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 44eeef0da186..745def862580 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -69,7 +69,7 @@ struct ieee1394_device_id {
>   * @bDeviceClass: Class of device; numbers are assigned
>   *     by the USB forum.  Products may choose to implement classes,
>   *     or be vendor-specific.  Device classes specify behavior of all
> - *     the interfaces on a devices.
> + *     the interfaces on a device.
>   * @bDeviceSubClass: Subclass of device; associated with bDeviceClass.
>   * @bDeviceProtocol: Protocol of device; associated with bDeviceClass.
>   * @bInterfaceClass: Class of interface; numbers are assigned
> --
> 1.9.1

Well whaddayaknow, I ran into the same thing last month.

https://lkml.org/lkml/2014/9/3/871

Cheers,
Frans
