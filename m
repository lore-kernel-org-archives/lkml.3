Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaAQWSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 17:18:20 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:34817 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaAQWSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 17:18:15 -0500
MIME-Version: 1.0
In-Reply-To: <1389961718-8130-2-git-send-email-LW@KARO-electronics.de>
References: <1389961718-8130-1-git-send-email-LW@KARO-electronics.de>
	<1389961718-8130-2-git-send-email-LW@KARO-electronics.de>
Date: Fri, 17 Jan 2014 16:18:14 -0600
Message-ID: <CAL_JsqKTJBZyHjsEYRgYdr6gqGSNtUK1HnOOM5ediH-xZci1mA@mail.gmail.com>
Subject: Re: [PATCHv3 1/4] DT: Add vendor prefix for Emerging Display Technologies
From: Rob Herring <robherring2@gmail.com>
To: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Silvio F <silvio.fricke@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jingoo Han <jg1.han@samsung.com>, Fugang Duan <B38611@freescale.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 6:28 AM, Lothar Waﬂmann <LW@karo-electronics.de> wrote:
>
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied.

Rob

>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index b458760..49774c3 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -29,6 +29,7 @@ dallas        Maxim Integrated Products (formerly Dallas Semiconductor)
>  davicom        DAVICOM Semiconductor, Inc.
>  denx   Denx Software Engineering
>  dmo    Data Modul AG
> +edt    Emerging Display Technologies
>  emmicro        EM Microelectronic
>  epson  Seiko Epson Corp.
>  est    ESTeem Wireless Modems
> --
> 1.7.2.5
>
