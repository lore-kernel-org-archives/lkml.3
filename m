Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab3EVVQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:16:09 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38970 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3EVVQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:16:07 -0400
Message-ID: <519D3594.4070305@kernel.org>
Date: Wed, 22 May 2013 22:16:04 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH] iio: exynos_adc: fix wrong structure extration in suspend
 and resume
References: <1369031689-23189-1-git-send-email-ch.naveen@samsung.com> <CAD=FV=Xppyb+Y0atygnwA8oBHmGHDx7Bit2fN12GX5Tt-Y9H1A@mail.gmail.com>
In-Reply-To: <CAD=FV=Xppyb+Y0atygnwA8oBHmGHDx7Bit2fN12GX5Tt-Y9H1A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 06:09 PM, Doug Anderson wrote:
> Naveen,
> 
> On Sun, May 19, 2013 at 11:34 PM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> The exynos_adc device structure was wrongly extracted from the dev*
>> correcting the same.
>>
>> Using the regular conversion of
>> struct device* -> struct platform_device* -> struct exynos_adc* seems wrong.
>> Instead we should be doing
>> struct device* -> struct iio_dev* -> struct exynos_adc*
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> ---
>>  drivers/iio/adc/exynos_adc.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
Applied to the fixes-togreg branch of iio.git
I'll hopefully send these on to Greg before the weekend.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
