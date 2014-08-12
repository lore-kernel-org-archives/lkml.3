Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaHLS6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 14:58:18 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38371 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaHLS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 14:58:16 -0400
Message-ID: <53EA63C1.2040302@collabora.co.uk>
Date: Tue, 12 Aug 2014 20:58:09 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] ARM: dts: Create cros-tps65090 fragment
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>	<1407861868-20097-4-git-send-email-javier.martinez@collabora.co.uk> <CAD=FV=XNsQ_8h-d8epU_gzWRH=A49a8iuirWCUe4TO6VGCvDSw@mail.gmail.com>
In-Reply-To: <CAD=FV=XNsQ_8h-d8epU_gzWRH=A49a8iuirWCUe4TO6VGCvDSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

Thanks for your feedback.

On 08/12/2014 07:26 PM, Doug Anderson wrote:
> Javier,
> 
> On Tue, Aug 12, 2014 at 9:44 AM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> The tps65090 PMU is a component used in many ChromeOS devices
>> so instead of having the same device tree definitions in many
>> files, create a .dtsi fragment that can be included in DTS.
>>
>> This fragment is based on the DT definitions for Peach boards.
>>
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>>  arch/arm/boot/dts/cros-tps65090.dtsi | 81 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 81 insertions(+)
>>  create mode 100644 arch/arm/boot/dts/cros-tps65090.dtsi
> 
> I'd probably skip this patch (just have duplication in pit vs. pi), or
> make it "peach" specific (like exynos-peach-tps65090.dtsi?).  This is
> really board-specific info and trying to guess what the various FETs
> are going to be for for all peach variants doesn't seem great.
>

Yes, I guess I went to far on the refactoring with this patch. Most likely I'll
drop the whole series anyway and just add the voltage constraints and parent
supplies to the board DTS, now that Mark explained to me that this refactoring
is actually doing more harm than good.

> -Doug
> 

Best regards,
Javier
