Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3GRRKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:10:24 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:35976 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890Ab3GRRKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:10:22 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak1mAJgg6FFV5qu1PGdsb2JhbABagwaDIoUjuH4EAYERFwMBAQEBODWCJAEBBTocEwEPEAgDGAklDwUlChoTiBS2LxaOXIEdB4MObgOXXIYzg3CKPzo
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="583259521"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 19:11:31 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 02/51] Input: atmel_mxt_ts - Improve T19 GPIO keys
 handling
Message-ID: <20130718171131.GA32381@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-3-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-3-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:48:37PM +0100, Nick Dyer wrote:
> 
>  * The mapping of the GPIO numbers into the T19 status byte varies between
>    different maXTouch chips. Some have up to 7 GPIOs. Allowing a keycode array
>    of up to 8 items is simpler and more generic. So replace #define with
>    configurable number of keys which also allows the removal of is_tp.
>  * Rename platform data parameters to include "t19" to prevent confusion with
>    T15 key array.
>  * Probe aborts early on when pdata is NULL, so no need to check.
>  * Move "int i" to beginning of function (mixed declarations and code)
>  * Use API calls rather than __set_bit()
>  * Remove unused dev variable.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   44 ++++++++++++------------------
>  drivers/platform/x86/chromeos_laptop.c   |   17 ++++++++----
>  include/linux/i2c/atmel_mxt_ts.h         |    7 ++---
>  3 files changed, 30 insertions(+), 38 deletions(-)

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
