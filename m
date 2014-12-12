Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030872AbaLLQlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:41:19 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39437 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <20141212162852.GA40238@snb.sh.intel.com>
References: <201412130004.58sFmPKu%fengguang.wu@intel.com>
	<20141212162852.GA40238@snb.sh.intel.com>
Date: Fri, 12 Dec 2014 18:41:15 +0200
X-Google-Sender-Auth: DiJMT0gLWYATuqF2EYVneS3jmYM
Message-ID: <CAEnQRZBc4=coYPy8-04oKB9OWCjD_CKovMYtmeV348-tLx2kpA@mail.gmail.com>
Subject: Re: [PATCH iio] iio: imu: kmx61: kmx61_set_wake_up_odr() can be static
From: Daniel Baluta <daniel.baluta@intel.com>
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>, kbuild-all@01.org,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 6:28 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> drivers/iio/imu/kmx61.c:422:5: sparse: symbol 'kmx61_set_wake_up_odr' was not declared. Should it be static?
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Reviewed-by: Daniel Baluta <daniel.baluta@intel.com>

> ---
>  kmx61.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index bda9c40..9b32f01 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -419,7 +419,7 @@ static int kmx61_get_mode(struct kmx61_data *data, u8 *mode, u8 device)
>         return 0;
>  }
>
> -int kmx61_set_wake_up_odr(struct kmx61_data *data, int val, int val2)
> +static int kmx61_set_wake_up_odr(struct kmx61_data *data, int val, int val2)
>  {
>         int ret, odr_bits;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
