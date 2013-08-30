Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3H3NAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 09:00:32 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50237 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3H3NA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 09:00:27 -0400
Date: Fri, 30 Aug 2013 13:59:19 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: ozwpan: change max. TX frame size supported.
Message-ID: <20130830125919.GB16484@laugharne.auvation.com>
References: <1377279213-17074-1-git-send-email-rupesh.gujare@atmel.com>
 <1377279213-17074-6-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377279213-17074-6-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 06:33:33PM +0100, Rupesh Gujare wrote:
> 
> diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
> index e532347..0c49c8a 100644
> --- a/drivers/staging/ozwpan/ozproto.h
> +++ b/drivers/staging/ozwpan/ozproto.h
> @@ -19,7 +19,7 @@
>  #define OZ_PRESLEEP_TOUT	11
>  
>  /* Maximun sizes of tx frames. */
      ^^^^^^^

If you are going to spin this patch again, you may as well fix this typo
too...

Cheers,

Mark
