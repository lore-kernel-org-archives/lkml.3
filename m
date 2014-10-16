Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaJPVDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:03:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35774 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaJPVDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:03:01 -0400
Date: Thu, 16 Oct 2014 14:02:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: xpad - add Thrustmaster as Xbox 360
 controller vendor
Message-ID: <20141016210257.GE38361@dtor-ws>
References: <1413371076-12390-1-git-send-email-tt.rantala@gmail.com>
 <1413371076-12390-2-git-send-email-tt.rantala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413371076-12390-2-git-send-email-tt.rantala@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 02:04:36PM +0300, Tommi Rantala wrote:
> Add Thrustmaster as Xbox 360 controller vendor. This is required for
> example to make the GP XID (044f:b326) gamepad work.
> 
> Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>

Applied both, thank you.

> ---
>  drivers/input/joystick/xpad.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index cee4fe3..2ed7905 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -293,6 +293,7 @@ static const signed short xpad_abs_triggers[] = {
>  
>  static struct usb_device_id xpad_table[] = {
>  	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
> +	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
>  	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
>  	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
>  	XPAD_XBOX360_VENDOR(0x046d),		/* Logitech X-Box 360 style controllers */
> -- 
> 1.9.3
> 

-- 
Dmitry
