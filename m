Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaJNHCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 03:02:30 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:48785 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbaJNHC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 03:02:29 -0400
MIME-Version: 1.0
In-Reply-To: <1409785103-14262-1-git-send-email-fransklaver@gmail.com>
References: <1409785103-14262-1-git-send-email-fransklaver@gmail.com>
Date: Tue, 14 Oct 2014 09:02:27 +0200
Message-ID: <CAH6sp9P3rfRTPyXt4jH_E6TiP6-xuXQCW7pO_FQhdDc6CqvY+w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mod_devicetable: fix incorrect plural
From: Frans Klaver <fransklaver@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 12:58 AM, Frans Klaver <fransklaver@gmail.com> wrote:
> Signed-off-by: Frans Klaver <fransklaver@gmail.com>
> ---
>  include/linux/mod_devicetable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 44eeef0..745def8 100644
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
> 2.1.0
>

Ping
