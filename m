Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbbATSID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:08:03 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42130 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693AbbATSIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:08:01 -0500
MIME-Version: 1.0
In-Reply-To: <20150114214649.GA20302@localhost.localdomain>
References: <20150114214649.GA20302@localhost.localdomain>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 20 Jan 2015 18:07:29 +0000
Message-ID: <CA+V-a8tzvfc7bT7sk5z4NZ7oLVQEw+tPKfPQeWDwmA=RGNZEHg@mail.gmail.com>
Subject: Re: [PATCH] staging: davinci_vpfe: fix space prohibited before
 semicolon warning
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: OSUOSL Drivers <devel@driverdev.osuosl.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the patch.

On Wed, Jan 14, 2015 at 9:46 PM, Aya Mahfouz
<mahfouz.saif.elyazal@gmail.com> wrote:
> This patch fixes the following checkpatch.pl warning:
>
> space prohibited before semicolon
>
> Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
> v1: This patch applies to Greg's tree.
>
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> index 704fa20..a425f71 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -901,7 +901,7 @@ static int ipipe_set_gbce_params(struct vpfe_ipipe_device *ipipe, void *param)
>         struct device *dev = ipipe->subdev.v4l2_dev->dev;
>
>         if (!gbce_param) {
> -               memset(gbce, 0 , sizeof(struct vpfe_ipipe_gbce));
> +               memset(gbce, 0, sizeof(struct vpfe_ipipe_gbce));
>         } else {
>                 memcpy(gbce, gbce_param, sizeof(struct vpfe_ipipe_gbce));
>                 if (ipipe_validate_gbce_params(gbce) < 0) {
> @@ -1086,7 +1086,7 @@ static int ipipe_set_car_params(struct vpfe_ipipe_device *ipipe, void *param)
>         struct vpfe_ipipe_car *car = &ipipe->config.car;
>
>         if (!car_param) {
> -               memset(car , 0, sizeof(struct vpfe_ipipe_car));
> +               memset(car, 0, sizeof(struct vpfe_ipipe_car));
>         } else {
>                 memcpy(car, car_param, sizeof(struct vpfe_ipipe_car));
>                 if (ipipe_validate_car_params(car) < 0) {
> --
> 1.9.3
>
