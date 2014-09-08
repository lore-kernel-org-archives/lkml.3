Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaIHVS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:18:26 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:60893 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbaIHVSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:18:23 -0400
Date: Mon, 8 Sep 2014 14:18:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Frank Razenberg <frank@zzattack.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: make xpad recognize Razer Sabertooth as 360
 controller
Message-ID: <20140908211819.GA18860@core.coreip.homeip.net>
References: <CAGL5hbP9+Qx6qa1anhiLBWOowrJi_4xwR-brCsCk5zKKeLBsfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGL5hbP9+Qx6qa1anhiLBWOowrJi_4xwR-brCsCk5zKKeLBsfw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:45:10PM +0200, Frank Razenberg wrote:
> The xpad driver recognizes Razer Sabertooth controllers as generic
> xbox controller, while it is really a 360 controller.
> This patch adds pid/vid mappings for the controller so that it is
> correctly recognized.
> 
> Signed-off-by: Frank Razenberg <frank@zzattack.org>
> ---
> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index 177602cf7079..113e30feadf9 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -171,6 +171,7 @@ static const struct xpad_device {
>         { 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0,
> XTYPE_XBOX360 },
>         { 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360
> },
>         { 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
> +       { 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
>         { 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
>         { 0x1bad, 0x0003, "Harmonix Rock Band Drumkit",
> MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
>         { 0x1bad, 0xf016, "Mad Catz Xbox 360 Controller", 0, XTYPE_XBOX360
> },

Applied, although next time please make sure your mailer does not mangle
the patch (it came to me line-wrapped with tabs replaced by spaces).

Thanks.

-- 
Dmitry
