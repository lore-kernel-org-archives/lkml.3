Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbbAPOLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:11:49 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:33449 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270AbbAPOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <1421402411-3479-2-git-send-email-chunyan.zhang@spreadtrum.com>
References: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com> <1421402411-3479-2-git-send-email-chunyan.zhang@spreadtrum.com>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 16 Jan 2015 08:11:23 -0600
Message-ID: <CAL_JsqL9hkfuGi-BmRHTZ=F3KVL8miu2LXkftbswpVuuSx0dtA@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] Documentation: DT: Renamed of-serial.txt to 8250.txt
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        Jason Cooper <jason@lakedaemon.net>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Andrew Lunn <andrew@lunn.ch>, Robert Richter <rrichter@cavium.com>,
        Hayato Suzuki <hytszk@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        Suravee Suthikulanit <Suravee.Suthikulpanit@amd.com>,
        Shawn Guo <shawn.guo@linaro.org>, lea.yan@linaro.org,
        jorge.ramirez-ortiz@linaro.org, Lee Jones <lee.jones@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        Lyra Zhang <zhang.lyra@gmail.com>, wei.qiao@spreadtrum.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 4:00 AM, Chunyan Zhang
<chunyan.zhang@spreadtrum.com> wrote:
> The file of-serial.txt was only for 8250 compatible UART implementations,
> so renamed it to 8250.txt to avoid confusing other persons.
> This is suggested by Arnd, see:
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-September/291455.html
>
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>

This is pretty much un-related to the rest of the series, so I will apply it.

Rob

> ---
>  .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
>
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/8250.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/serial/of-serial.txt
> rename to Documentation/devicetree/bindings/serial/8250.txt
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
