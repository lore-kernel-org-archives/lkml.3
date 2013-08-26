Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3HZQM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:12:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32771 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3HZQM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:12:26 -0400
Date: Mon, 26 Aug 2013 19:12:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        mujeeb.adil@gmail.com, justinmattock@gmail.com
Subject: Re: [PATCH 09/24] Staging: winbond: reg: fixed some lines over 80
 characters
Message-ID: <20130826161205.GD6329@mwanda>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-10-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-10-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:08PM +0200, Iker Pedrosa wrote:
> First of the patches that fixes the lines over 80 characters in reg.c
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
> ---
>  drivers/staging/winbond/reg.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
> index 61916f5..b1d977a 100644
> --- a/drivers/staging/winbond/reg.c
> +++ b/drivers/staging/winbond/reg.c
> @@ -809,12 +809,12 @@ u32 w89rf242_txvga_data[][5] = {
>  	{(0x05 << 24) | 0x24C7CA, 34, 0x00292315, 0x0800FEFF, 0x72724242}
>  };
>  
> -/* ================================================================================================== */
> +/* ========================================================================= */

Just delete these.  They are not kernel style.

regards,
dan carpenter

