Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaIHNso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:48:44 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36806 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaIHNsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:48:42 -0400
Date: Mon, 8 Sep 2014 19:18:28 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Morgan Phillips <winter2718@gmail.com>
Cc: brijohn@gmail.com, hdegoede@redhat.com, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        wolfram@the-dreams.de
Subject: Re: [PATCH] [media]: sn9c20x.c: fix checkpatch error: that open
 brace { should be on the previous line
Message-ID: <20140908134828.GA7617@sudip-PC>
References: <1410179542-3272-1-git-send-email-winter2718@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410179542-3272-1-git-send-email-winter2718@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 07:32:22AM -0500, Morgan Phillips wrote:
> Signed-off-by: Morgan Phillips <winter2718@gmail.com>

no commit message ?

thanks
sudip

> ---
>  drivers/media/usb/gspca/sn9c20x.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
> index 41a9a89..95467f0 100644
> --- a/drivers/media/usb/gspca/sn9c20x.c
> +++ b/drivers/media/usb/gspca/sn9c20x.c
> @@ -1787,8 +1787,9 @@ static int sd_init(struct gspca_dev *gspca_dev)
>  	struct sd *sd = (struct sd *) gspca_dev;
>  	int i;
>  	u8 value;
> -	u8 i2c_init[9] =
> -		{0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03};
> +	u8 i2c_init[9] = {
> +		0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03
> +	};
>  
>  	for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
>  		value = bridge_init[i][1];
> @@ -2242,8 +2243,9 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
>  {
>  	struct sd *sd = (struct sd *) gspca_dev;
>  	int avg_lum, is_jpeg;
> -	static const u8 frame_header[] =
> -		{0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
> +	static const u8 frame_header[] = {
> +		0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96
> +	};
>  
>  	is_jpeg = (sd->fmt & 0x03) == 0;
>  	if (len >= 64 && memcmp(data, frame_header, 6) == 0) {
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
