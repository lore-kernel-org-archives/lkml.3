Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936340Ab3DQRyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:54:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:57683 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935915Ab3DQRyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:54:17 -0400
Message-ID: <516EE1B9.6000206@infradead.org>
Date: Wed, 17 Apr 2013 10:54:01 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: Export matrix_keypad_parse_of_params()
References: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/13 01:50, Michal Marek wrote:
> Couple of input drivers depend on this symbol:
> 
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
> ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

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
> 


-- 
~Randy
