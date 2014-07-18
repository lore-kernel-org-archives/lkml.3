Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945930AbaGRTJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:09:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39018 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030601AbaGRTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:09:39 -0400
Message-ID: <53C970EB.9020006@samsung.com>
Date: Sat, 19 Jul 2014 04:09:31 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
CC: Kukjin Kim <kgene.kim@samsung.com>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        khilman@linaro.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org, sjg@chromium.org,
        ijc+devicetree@hellion.org.uk, tushar.b@samsung.com,
        Doug Anderson <dianders@chromium.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, ajaynumb@gmail.com,
        robh+dt@kernel.org, ben-linux@fluff.org, galak@codeaurora.org,
        olof@lixom.net, ch.naveen@samsung.com,
        linux-arm-kernel@lists.infradead.org, rahul.sharma@samsung.com
Subject: Re: [PATCH v3] ARM: dts: Add cros_ec to exynos5420-peach-pit and
 exynos5800-peach-pi
References: <1403627332-4688-1-git-send-email-dianders@chromium.org> <53C8514F.4040606@collabora.co.uk>
In-Reply-To: <53C8514F.4040606@collabora.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/14 07:42, Javier Martinez Canillas wrote:
> Hello Kukjin,
>
Hi,

> On 06/24/2014 06:28 PM, Doug Anderson wrote:
>> This adds cros_ec to exynos5420-peach-pit and exynos5800-peach-pi,
>> including:
>> * The keyboard
>> * The i2c tunnel
>> * The tps65090 under the i2c tunnel
>> * The battery under the i2c tunnel
>>
>> To add extra motivation, it should be noted that tps65090 is one of
>> the things needed to get display-related FETs turned on for pit and
>> pi.
>>
>> Note that this relies on a few outstanding changes:
>> * Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
>>    (spi: s3c64xx: for DT platofrms always get the chipselect info from
>>    DT node) to work properly and match the documented bindings.  See
>>    <https://patchwork.kernel.org/patch/4346701/>  and
>>    <https://patchwork.kernel.org/patch/4346711/>
>>
>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>> Tested-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
>> Tested-by: Tushar Behera<tushar.b@samsung.com>
>>
>
> Mark Brown as already applied the SPI DT binding fix from Naveen [0] which was
> the dependency for this patch and he said that will try to send the whole series
> to Torvalds before the 3.16-rc cycle ends.
>
Thanks for your gentle reminder ;-)

> So I think that it's safe now if you want to pick this patch.
>
Sure, I've applied.

> Thanks a lot!
>
Many thanks.

- Kukjin

> Best regards,
> Javier
>
> [0]:
> https://git.kernel.org/cgit/linux/kernel/git/broonie/spi.git/commit/?h=for-next&id=306972cedfdedc662dd8e32a6397d0e29f2ac90e
