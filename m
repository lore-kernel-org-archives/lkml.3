Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaDYPqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:46:38 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:48545 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaDYPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:46:33 -0400
MIME-Version: 1.0
In-Reply-To: <1398420888-5506-2-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
	<1398420888-5506-2-git-send-email-ch.naveen@samsung.com>
Date: Fri, 25 Apr 2014 08:46:31 -0700
X-Google-Sender-Auth: JOpt2JULDXE0ju59m8JbY_00xcs
Message-ID: <CAD=FV=V28_iDiNWeX6bXLzMW5kWygJz-YAExJkETJKgTDicHQg@mail.gmail.com>
Subject: Re: [PATCH 1/5] iio: exynos_adc: use indio_dev->dev structure to
 handle child nodes
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

Thanks for sending this.  Given that Jonathan Cameron was involved in
the previous discussion, it probably would have been wise to include
him on the CC list.

On Fri, Apr 25, 2014 at 3:14 AM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> Using pdev->dev with device_for_each_child() would iterate over all
> of the children of the platform device and delete them.
> Thus, causing crashes during module unload.
>
> We should be using the indio_dev->dev structure for
> registering/unregistering child nodes.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> ---
> This change was tested on top of
>    https://lkml.org/lkml/2014/4/21/481 from Doug.
>
>  drivers/iio/adc/exynos_adc.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reported-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
