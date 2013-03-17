Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3CQWmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:42:31 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49150 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab3CQWm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:42:29 -0400
Message-ID: <514623A8.5000905@kernel.org>
Date: Sun, 17 Mar 2013 20:12:24 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] iio: adc: Kconfig: exynos_adc depends on CONFIG_OF
References: <1363364620-23597-1-git-send-email-ch.naveen@samsung.com> <CAD=FV=W90mKzmpg4cG_JJ6R6Of1jt=TxOe_1h-nvzs7KeAvDXQ@mail.gmail.com>
In-Reply-To: <CAD=FV=W90mKzmpg4cG_JJ6R6Of1jt=TxOe_1h-nvzs7KeAvDXQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 06:09 PM, Doug Anderson wrote:
> Naveen,
> 
> On Fri, Mar 15, 2013 at 9:23 AM, Naveen Krishna Chatradhi
> <ch.naveen@samsung.com> wrote:
>> As the exynos_adc driver only supports device tree registration.
>> Making driver depend on CONFIG_OF solves possible errors during probe.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Cc: Doug Anderson <dianders@chromium.org>
>> Cc: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>> Discussion thread for this patch can be found at
>> http://www.gossamer-threads.com/lists/linux/kernel/1693284?page=last
>>
>>  drivers/iio/adc/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
> 
> Reviewed-by: Doug Anderson <dianders@chromium.org>
Applied to togreg branch of iio.git, thanks,

> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
