Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3FZQHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:07:33 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62632 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FZQHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:07:32 -0400
Date: Wed, 26 Jun 2013 09:07:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, jkosina@suse.cz,
        Todd Showalter <todd@electronjump.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] input: document gamepad API and add extra keycodes
Message-ID: <20130626160727.GA32420@core.coreip.homeip.net>
References: <1371303165-1802-1-git-send-email-dh.herrmann@gmail.com>
 <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371303165-1802-2-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Jiri,

On Sat, Jun 15, 2013 at 03:32:44PM +0200, David Herrmann wrote:
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -507,10 +507,14 @@ struct input_keymap_entry {
>  
>  #define BTN_GAMEPAD		0x130
>  #define BTN_A			0x130
> +#define BTN_SOUTH		0x130

Could we do:

#define BTN_SOUTH		0x130
#define BTN_A			BTN_SOUTH

so that it is clear that BTN_A, BTN_B, etc are legacy definitions and
not an accidental typos that need their own key codes.

Otherwise:

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

>  #define BTN_B			0x131
> +#define BTN_EAST		0x131
>  #define BTN_C			0x132
>  #define BTN_X			0x133
> +#define BTN_NORTH		0x133
>  #define BTN_Y			0x134
> +#define BTN_WEST		0x134
>  #define BTN_Z			0x135
>  #define BTN_TL			0x136
>  #define BTN_TR			0x137
> @@ -702,6 +706,11 @@ struct input_keymap_entry {
>  #define KEY_CAMERA_LEFT		0x219
>  #define KEY_CAMERA_RIGHT	0x21a
>  
> +#define BTN_DPAD_UP		0x220
> +#define BTN_DPAD_DOWN		0x221
> +#define BTN_DPAD_LEFT		0x222
> +#define BTN_DPAD_RIGHT		0x223
> +
>  #define BTN_TRIGGER_HAPPY		0x2c0
>  #define BTN_TRIGGER_HAPPY1		0x2c0
>  #define BTN_TRIGGER_HAPPY2		0x2c1
> -- 
> 1.8.3.1
> 

Thanks.

-- 
Dmitry
