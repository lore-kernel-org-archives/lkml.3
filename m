Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3DOQH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:07:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64229 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3DOQH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:07:56 -0400
Date: Mon, 15 Apr 2013 09:07:47 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-input@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Export matrix_keypad_parse_of_params()
Message-ID: <20130415160747.GA19223@core.coreip.homeip.net>
References: <1366027608-17395-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366027608-17395-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Mon, Apr 15, 2013 at 02:06:48PM +0200, Michal Marek wrote:
> Couple of input drivers depend on this symbol:
> 
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

This is coming through some other tree though so you 'll have to track
it down.

Thanks.

> ---
>  drivers/input/matrix-keymap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
> index 619b382..08b61f5 100644
> --- a/drivers/input/matrix-keymap.c
> +++ b/drivers/input/matrix-keymap.c
> @@ -68,6 +68,7 @@ int matrix_keypad_parse_of_params(struct device *dev,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(matrix_keypad_parse_of_params);
>  
>  static int matrix_keypad_parse_of_keymap(const char *propname,
>  					 unsigned int rows, unsigned int cols,
> -- 
> 1.8.2.1
> 

-- 
Dmitry
