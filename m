Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965993AbaFSWIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:08:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965475AbaFSWIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:08:17 -0400
Date: Thu, 19 Jun 2014 15:12:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: dan.carpenter@oracle.com, burzalodowa@gmail.com, andrea.merello@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: rtl8192u: r8192U_wx.c Fixed one misplaced
 brace
Message-ID: <20140619221217.GA5764@kroah.com>
References: <1401396321-29363-1-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401396321-29363-1-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:45:17PM -0700, Chaitanya Hazarey wrote:
> Fixed a misplaced brace in the r8192_wx_set_scan_type function.
> 
> Signed-off-by: Chaitanya Hazarey <c@24.io>
> ---
>  drivers/staging/rtl8192u/r8192U_wx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
> index 1af7c5d..675a12d 100644
> --- a/drivers/staging/rtl8192u/r8192U_wx.c
> +++ b/drivers/staging/rtl8192u/r8192U_wx.c
> @@ -616,7 +616,8 @@ static int r8192_wx_set_enc(struct net_device *dev,
>  
>  
>  static int r8192_wx_set_scan_type(struct net_device *dev, struct iw_request_info *aa,
> -					union iwreq_data *wrqu, char *p){
> +					union iwreq_data *wrqu, char *p)

This patch doesn't apply :(

