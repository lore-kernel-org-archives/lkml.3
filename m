Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaK0MJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:09:01 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44592 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaK0MIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141127113819.GD857@leverpostej>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-2-git-send-email-chunyan.zhang@spreadtrum.com>
	<20141127113819.GD857@leverpostej>
Date: Thu, 27 Nov 2014 20:08:51 +0800
Message-ID: <CAAfSe-uGF2DbE894ij9ezH7dZuU_iMWX4G-Lb77CoZ1ApS_vgg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-27 19:38 GMT+08:00 Mark Rutland <mark.rutland@arm.com>:
> On Tue, Nov 25, 2014 at 12:16:54PM +0000, Chunyan Zhang wrote:
>> The file of-serial.txt was only for 8250 compatible UART implementations,
>> so renamed it to 8250.txt to avoid confusing other persons.
>> This is recommended by Arnd, see:
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html
>>
>> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
>
> My prior Ack [1] still applies (given you've just changed the way the
> patch was generated, as Arnd and I suggested).
>
OK, I'll add in v4.

> Mark.
>
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/295152.html
>
>> ---
>>  .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
>>  1 file changed, 0 insertions(+), 0 deletions(-)
>>  rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
>>
>> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/8250.txt
>> similarity index 100%
>> rename from Documentation/devicetree/bindings/serial/of-serial.txt
>> rename to Documentation/devicetree/bindings/serial/8250.txt
>> --
>> 1.7.9.5
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
