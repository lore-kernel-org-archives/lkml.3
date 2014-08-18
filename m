Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaHRS1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:27:53 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:61440 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRS1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:27:51 -0400
Message-ID: <53F245A4.5010106@samsung.com>
Date: Mon, 18 Aug 2014 13:27:48 -0500
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH 1/2] ARM: dts: Improve Peach Pit and Pi power scheme
References: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=UbckfwGucuPjEtHixVgF5K2fD5N3EPS2BH96DRDACuqw@mail.gmail.com>
In-Reply-To: <CAD=FV=UbckfwGucuPjEtHixVgF5K2fD5N3EPS2BH96DRDACuqw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/14 10:46, Doug Anderson wrote:
> Javier,
>
> On Mon, Aug 11, 2014 at 4:38 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk>  wrote:
>> The DeviceTree files for the Peach Pit and Pi machines have
>> a simplistic model of the connections between the different
>> regulators since not all the tps65090 regulators get their
>> input supply voltage from the VDC. DCDC1-3, LD0-1 and fet7
>> parent supply is indded VDC but the fet1-6 get their input
>> supply from the DCDC1 and DCDC2 output voltage rails.
>>
>> Update the DeviceTree to better reflect the real connections
>> between tps65090 regulators. Having this information in the
>> DTS is useful since FETs are switches that don't provide an
>> output voltage so the regulator core needs to fetch the FET
>> parent output voltage if the child voltage is queried.
>>
>> Signed-off-by: Javier Martinez Canillas<javier.martinez@collabora.co.uk>
>> Acked-by: Mark Brown<broonie@linaro.org>
>> ---
>>   arch/arm/boot/dts/exynos5420-peach-pit.dts | 12 ++++++------
>>   arch/arm/boot/dts/exynos5800-peach-pi.dts  | 12 ++++++------
>>   2 files changed, 12 insertions(+), 12 deletions(-)
>
> Matches my schematics.  Kukjin: I think this could be applied to
> for-next whenever it's convenient.
>
OK, I've applied this but 2nd in this series...

> Acked-by: Doug Anderson<dianders@chromium.org>
>
Thanks,
Kukjin
