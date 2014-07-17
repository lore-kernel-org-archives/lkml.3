Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395AbaGQLyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:54:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:49314 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaGQLyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <1405595993-16661-2-git-send-email-ch.naveen@samsung.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
	<1405595993-16661-2-git-send-email-ch.naveen@samsung.com>
Date: Thu, 17 Jul 2014 17:24:38 +0530
Message-ID: <CAK5sBcFR0nwmL97CYxhHHhwHREdNOMYZnc2DF+O=WdQLBHQbLA@mail.gmail.com>
Subject: Re: [PATCH 1/4 v2] iio: exyno-adc: use syscon for PMU register access
From: Sachin Kamat <spk.linux@gmail.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, cpgs@samsung.com,
        Grant Grundler <grundler@chromium.org>, jic23@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Thu, Jul 17, 2014 at 4:49 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch updates the IIO based ADC driver to use syscon and regmap
> APIs to access and use PMU registers instead of remapping the PMU
> registers in the driver.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> To: linux-iio@vger.kernel.org

With only this patch applied, I believe the ADC functionality would be broken.
Perhaps the DT changes should be merged along with this patch?

-- 
Regards,
Sachin.
