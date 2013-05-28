Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab3E1GRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:17:41 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:50763 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977Ab3E1GRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:17:38 -0400
Date: Tue, 28 May 2013 01:17:05 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Raise the maximum number of usb-serial devices to 256
To: Tobias Winter <tobias@linuxdingsda.de>
Cc: linux-usb@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <51A327A4.7020908@linuxdingsda.de> (from tobias@linuxdingsda.de
	on Mon May 27 04:30:12 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369721825.2776.36@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 04:30:12 AM, Tobias Winter wrote:
> Raise the maximum number of usb-serial devices to 256, which is the
> actual limit supported by the codebase.
> 
> Signed-off-by: Jakob-Tobias Winter <tobias@linuxdingsda.de>
> Tested-by: Jakob-Tobias Winter <tobias@linuxdingsda.de>
> 
> ---
>  include/linux/usb/serial.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> index 302ddf5..c0ce5ed 100644
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -20,7 +20,7 @@
>  #include <linux/kfifo.h>
> 
>  #define SERIAL_TTY_MAJOR       188     /* Nice legal number now */
> -#define SERIAL_TTY_MINORS      254     /* loads of devices :) */
> +#define SERIAL_TTY_MINORS      256     /* loads of devices :) */
>  #define SERIAL_TTY_NO_MINOR    255     /* No minor was assigned */

So SERIAL_TTY_NO_MINOR is now a valid minor?

Rob