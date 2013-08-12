Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3HLKHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:07:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60292 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3HLKGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:06:55 -0400
Date: Mon, 12 Aug 2013 12:06:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: gregkh@linuxfoundation.org, justinmattock@gmail.com, mujeeb.adil@gmail.com,
        harsh1kumar@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] Staging: winbond: mds_f: fixed lines over 80
 characters
Message-ID: <20130812100653.GA21588@amd.pavel.ucw.cz>
References: <1375696712-5276-1-git-send-email-ikerpedrosam@gmail.com>
 <1375696712-5276-6-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375696712-5276-6-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-05 11:58:31, Iker Pedrosa wrote:
> Fixed some coding style issues.
> 
> Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>

ACK.

> ---
>  drivers/staging/winbond/mds_f.h | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mds_f.h b/drivers/staging/winbond/mds_f.h
> index ce8be07..ce5a78c 100644
> --- a/drivers/staging/winbond/mds_f.h
> +++ b/drivers/staging/winbond/mds_f.h
> @@ -7,13 +7,17 @@
>  unsigned char Mds_initial(struct wbsoft_priv *adapter);
>  void Mds_Tx(struct wbsoft_priv *adapter);
>  void Mds_SendComplete(struct wbsoft_priv *adapter, struct T02_descriptor *pt02);
> -void Mds_MpduProcess(struct wbsoft_priv *adapter, struct wb35_descriptor *prxdes);
> +void Mds_MpduProcess(struct wbsoft_priv *adapter,
> +		     struct wb35_descriptor *prxdes);
>  extern void DataDmp(u8 *pdata, u32 len, u32 offset);
>  
>  /* For data frame sending */
>  u16 MDS_GetPacketSize(struct wbsoft_priv *adapter);
> -void MDS_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
> -void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter, struct wb35_descriptor *pdes);
> -void MDS_SendResult(struct wbsoft_priv *adapter, u8 packetid, unsigned char sendok);
> +void MDS_GetNextPacket(struct wbsoft_priv *adapter,
> +		       struct wb35_descriptor *pdes);
> +void MDS_GetNextPacketComplete(struct wbsoft_priv *adapter,
> +			       struct wb35_descriptor *pdes);
> +void MDS_SendResult(struct wbsoft_priv *adapter, u8 packetid,
> +		    unsigned char sendok);
>  
>  #endif

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
