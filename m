Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3HLKF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:05:28 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013Ab3HLKFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:05:24 -0400
Date: Mon, 12 Aug 2013 12:05:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] Staging: winbond: wb35reg: white space deleted
Message-ID: <20130812100522.GB21492@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
 <1375696712-5276-3-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375696712-5276-3-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-05 11:58:28, Iker Pedrosa wrote:
> White space deleted before a semicolon.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/wb35reg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
> index 34a2618..1314f93 100644
> --- a/drivers/staging/winbond/wb35reg.c
> +++ b/drivers/staging/winbond/wb35reg.c
> @@ -44,7 +44,7 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
>  	reg_queue->pBuffer = (u32 *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue));
>  	memcpy(reg_queue->pBuffer, pRegisterData, DataSize);
>  	/* the function for reversing register data from little endian to big endian */
> -	for (i = 0; i < NumberOfData ; i++)
> +	for (i = 0; i < NumberOfData; i++)
>  		reg_queue->pBuffer[i] = cpu_to_le32(reg_queue->pBuffer[i]);
>  
>  	dr = (struct usb_ctrlrequest *)((u8 *)reg_queue + sizeof(struct wb35_reg_queue) + DataSize);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
