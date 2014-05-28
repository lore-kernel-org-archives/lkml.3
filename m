Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaE1XZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:25:05 -0400
Received: from mail-yk0-f172.google.com ([209.85.160.172]:36373 "EHLO
	mail-yk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbaE1XVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:21:03 -0400
MIME-Version: 1.0
X-Originating-IP: [128.107.151.95]
In-Reply-To: <1401319048-15797-1-git-send-email-c@24.io>
References: <1401319048-15797-1-git-send-email-c@24.io>
Date: Wed, 28 May 2014 16:21:02 -0700
Message-ID: <CADadk9ExTYrK-vM0_UK7Oc8UAc98u9jKAXHbFqvU02_PkO4JnQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: rtl8192u: r8192U_wx.c Fixed misplaced brace
From: Chaitanya Hazarey <c@24.io>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ksenia Ragiadakou <burzalodowa@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chaitanya Hazarey <c@24.io>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch, there seems something wrong with it, will
resend with a new subject.

Thanks,

Chaitanya

On Wed, May 28, 2014 at 4:17 PM, Chaitanya Hazarey <c@24.io> wrote:
> Fixed a misplaced brace in a function
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
> -                                       union iwreq_data *wrqu, char *p){
> +                                       union iwreq_data *wrqu, char *p)
> +{
>
>         struct r8192_priv *priv = ieee80211_priv(dev);
>         int *parms = (int *)p;
> --
> 1.9.1
>
