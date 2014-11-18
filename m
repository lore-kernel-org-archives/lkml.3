Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaKRRuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:50:10 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:48333 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaKRRuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:50:05 -0500
MIME-Version: 1.0
In-Reply-To: <1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1416246184-29071-1-git-send-email-javier.martinez@collabora.co.uk>
	<1416246184-29071-2-git-send-email-javier.martinez@collabora.co.uk>
Date: Tue, 18 Nov 2014 09:50:04 -0800
X-Google-Sender-Auth: Itk65spWZTtTIk4tF_g26k4u0bE
Message-ID: <CAD=FV=Xkei_wxa3jWb8bPvuynbSyq4o=ezjVD0+e04aOPCAM+Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: dts: Add SPI flash node for Peach boards
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Simon Glass <sjg@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Nov 17, 2014 at 9:43 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> +&spi_1 {
> +       status = "okay";
> +       samsung,spi-src-clk = <0>;
> +       num-cs = <1>;
> +       cs-gpios = <&gpa2 5 0>;
> +
> +       spidev@0 {
> +               compatible = "spidev";

This is common practice in the Chrome OS tree, but we've gotten
pushback from upstream questioning about whether "spidev" is really a
physical device.  See:

http://www.spinics.net/lists/linux-samsung-soc/msg29563.html


I don't really have an answer for something better to do here but I
figured I'd at least bring up the point.

-Doug
