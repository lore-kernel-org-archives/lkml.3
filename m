Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507AbaBFICa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:02:30 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:50113 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaBFICU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:02:20 -0500
MIME-Version: 1.0
In-Reply-To: <1391615773-26467-1-git-send-email-marcus.folkesson@gmail.com>
References: <1391615773-26467-1-git-send-email-marcus.folkesson@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 6 Feb 2014 13:31:59 +0530
Message-ID: <CA+V-a8tZ9h1K10b9D8469Jd03g8y81JnBmv95a0=PRTWDmkR5w@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: Kconfig: create dependency to
 MEDIA_CONTROLLER for adv7*
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Martin Bugge <martin.bugge@cisco.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

On Wed, Feb 5, 2014 at 9:26 PM, Marcus Folkesson
<marcus.folkesson@gmail.com> wrote:
> These chips makes use of the media_entity in the v4l2_subdev struct
> and is therefor dependent of the  MEDIA_CONTROLLER config.
>
NAK, as you can currently see these drivers depend on VIDEO_V4L2_SUBDEV_API
config and if you see VIDEO_V4L2_SUBDEV_API depends on MEDIA_CONTROLLER
config so there is no point in adding this dependency.

Thanks,
--Prabhakar Lad

> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  drivers/media/i2c/Kconfig |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index d18be19..1771b77 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -196,7 +196,7 @@ config VIDEO_ADV7183
>
>  config VIDEO_ADV7604
>         tristate "Analog Devices ADV7604 decoder"
> -       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
>         ---help---
>           Support for the Analog Devices ADV7604 video decoder.
>
> @@ -208,7 +208,7 @@ config VIDEO_ADV7604
>
>  config VIDEO_ADV7842
>         tristate "Analog Devices ADV7842 decoder"
> -       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
>         ---help---
>           Support for the Analog Devices ADV7842 video decoder.
>
> @@ -431,7 +431,7 @@ config VIDEO_ADV7393
>
>  config VIDEO_ADV7511
>         tristate "Analog Devices ADV7511 encoder"
> -       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +       depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API && MEDIA_CONTROLLER
>         ---help---
>           Support for the Analog Devices ADV7511 video encoder.
>
> --
> 1.7.10.4
>
