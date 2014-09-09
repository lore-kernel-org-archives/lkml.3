Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaIISYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:24:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58683 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaIISYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:24:02 -0400
Date: Tue, 9 Sep 2014 11:23:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: linux-kernel@vger.kernel.org, broonie@kernel.org,
        linux-input@vger.kernel.org, lrg@slimlogic.co.uk,
        rdunlap@infradead.org
Subject: Re: [PATCH] Input:wm971x: Fix typo in module param description of
 wm971[23].c
Message-ID: <20140909182357.GC28774@core.coreip.homeip.net>
References: <1410260568-13955-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410260568-13955-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:02:48PM +0900, Masanari Iida wrote:
> This patch fix spelling typo in module parameter
> description of wm9712.c and wm9713.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thank you.

> ---
>  drivers/input/touchscreen/wm9712.c | 2 +-
>  drivers/input/touchscreen/wm9713.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/wm9712.c b/drivers/input/touchscreen/wm9712.c
> index 16b5211..705ffa1 100644
> --- a/drivers/input/touchscreen/wm9712.c
> +++ b/drivers/input/touchscreen/wm9712.c
> @@ -41,7 +41,7 @@
>   */
>  static int rpu = 8;
>  module_param(rpu, int, 0);
> -MODULE_PARM_DESC(rpu, "Set internal pull up resitor for pen detect.");
> +MODULE_PARM_DESC(rpu, "Set internal pull up resistor for pen detect.");
>  
>  /*
>   * Set current used for pressure measurement.
> diff --git a/drivers/input/touchscreen/wm9713.c b/drivers/input/touchscreen/wm9713.c
> index 7405353..572a5a6 100644
> --- a/drivers/input/touchscreen/wm9713.c
> +++ b/drivers/input/touchscreen/wm9713.c
> @@ -41,7 +41,7 @@
>   */
>  static int rpu = 8;
>  module_param(rpu, int, 0);
> -MODULE_PARM_DESC(rpu, "Set internal pull up resitor for pen detect.");
> +MODULE_PARM_DESC(rpu, "Set internal pull up resistor for pen detect.");
>  
>  /*
>   * Set current used for pressure measurement.
> -- 
> 2.1.0.60.g85f0837
> 

-- 
Dmitry
