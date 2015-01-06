Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbbAFSbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:31:48 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:50669 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbbAFSbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:31:46 -0500
Message-ID: <54AC2A0B.3040807@cogentembedded.com>
Date: Tue, 06 Jan 2015 21:31:39 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: vt8500lcdfb: remove unneeded continue
References: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1420548302-11489-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/06/2015 03:45 PM, Sudip Mukherjee wrote:

> continue is not needed at the end of a for loop

> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>   drivers/video/fbdev/vt8500lcdfb.c | 1 -
>   1 file changed, 1 deletion(-)

> diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
> index ffaf29e..6716bf5 100644
> --- a/drivers/video/fbdev/vt8500lcdfb.c
> +++ b/drivers/video/fbdev/vt8500lcdfb.c
> @@ -115,7 +115,6 @@ static int vt8500lcd_set_par(struct fb_info *info)
>   	for (i = 0; i < 8; i++) {
>   		if (bpp_values[i] == info->var.bits_per_pixel) {
>   			reg_bpp = i;
> -			continue;
>   		}

    {} are not needed any more either. ;-)

[...]

WBR, Sergei

