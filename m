Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJFHp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 03:45:58 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1140 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaJFHpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 03:45:55 -0400
Message-ID: <5432489A.60202@xs4all.nl>
Date: Mon, 06 Oct 2014 09:45:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Stevean Raja Kumar <rk.stevean@gmail.com>, m.chehab@samsung.com,
        gregkh@linuxfoundation.org, aybuke.147@gmail.com,
        tapaswenipathak@gmail.com, paul.gortmaker@windriver.com,
        monamagarwal123@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: Added semicolon.
References: <20141004184316.GA6561@srkjfone>
In-Reply-To: <20141004184316.GA6561@srkjfone>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2014 08:43 PM, Stevean Raja Kumar wrote:
> Added semicolon for the line usleep_range(10000, 11000);

Against which kernel is this patch? I don't see a usleep_range in either the mainline
kernel or the media_tree.git kernel.

Regards,

	Hans

> 
> Signed-off-by: Stevean Raja Kumar <rk.stevean@gmail.com>
> ---
>  drivers/staging/media/cxd2099/cxd2099.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
> index cda1595..657ea48 100644
> --- a/drivers/staging/media/cxd2099/cxd2099.c
> +++ b/drivers/staging/media/cxd2099/cxd2099.c
> @@ -527,7 +527,7 @@ static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
>  		u8 val;
>  #endif
>  		for (i = 0; i < 100; i++) {
> -			usleep_range(10000, 11000)
> +			usleep_range(10000, 11000);
>  #if 0
>  			read_reg(ci, 0x06, &val);
>  			dev_info(&ci->i2c->dev, "%d:%02x\n", i, val);
> 

