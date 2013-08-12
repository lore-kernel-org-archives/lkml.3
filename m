Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3HLKHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:07:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60300 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab3HLKHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:07:05 -0400
Date: Mon, 12 Aug 2013 12:07:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] Staging: winbond: mds_f: deleted extern function
Message-ID: <20130812100703.GB21588@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
 <1375696712-5276-7-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375696712-5276-7-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-05 11:58:32, Iker Pedrosa wrote:
> Deleted an extern function that wasn't used in this driver.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/mds_f.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
> index ce5a78c..159b2eb 100644
> --- a/drivers/staging/winbond/mds_f.h
> +++ b/drivers/staging/winbond/mds_f.h
> @@ -9,7 +9,6 @@ void Mds_Tx(struct wbsoft_priv *adapter);
>  void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
>  void Mds_MpduProcess(struct wbsoft_priv *adapter,
>  		     struct wb35_descriptor *prxdes);
> -extern void DataDmp(u8 *pdata, u32 len, u32 offset);
>  
>  /* For data frame sending */
>  u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
