Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3J0Nv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:51:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3J0Nvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:51:55 -0400
Date: Sun, 27 Oct 2013 06:53:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes =?iso-8859-1?Q?L=F6thberg?= <johannes@kyriasis.com>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Andres More <more.andres@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: vt6656: fix code indenting error in power.c
Message-ID: <20131027135342.GA17564@kroah.com>
References: <1382592407-26728-1-git-send-email-johannes@kyriasis.com>
 <1382592407-26728-3-git-send-email-johannes@kyriasis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382592407-26728-3-git-send-email-johannes@kyriasis.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 07:26:47AM +0200, Johannes Löthberg wrote:
> This patch fixes a code indentation error found by checkpatch.pl
> where a line was indented with spaces instead of tabs
> 
> Signed-off-by: Johannes Löthberg <johannes@kyriasis.com>
> ---
>  drivers/staging/vt6656/power.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
> index 3002061..a14a2bf 100644
> --- a/drivers/staging/vt6656/power.c
> +++ b/drivers/staging/vt6656/power.c
> @@ -268,7 +268,7 @@ int PSbSendNullPacket(struct vnt_private *pDevice)
>  		+ sizeof(struct vnt_tx_mgmt));
>  
>  	flags = WLAN_SET_FC_FTYPE(WLAN_TYPE_DATA) |
> -                        WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);
> +		WLAN_SET_FC_FSTYPE(WLAN_FSTYPE_NULL);

No, indent this line properly using tabs to where the spaces were,
that's the correct location.

greg k-h
