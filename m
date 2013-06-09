Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635Ab3FIVgS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 17:36:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3FIVgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 17:36:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, kevin@allwinnertech.com
Subject: Re: [PATCH 4/6] ARM: sunxi: dt: Add Allwinner A10s DTSI
Date: Sun, 09 Jun 2013 23:36:24 +0200
Message-ID: <3346364.JR9UrJYqP8@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370795767-9769-5-git-send-email-maxime.ripard@free-electrons.com>
References: <1370795767-9769-1-git-send-email-maxime.ripard@free-electrons.com> <1370795767-9769-5-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Y+BK20HDAgupBoYy2Ii/iNm8L5HDWjzaatQy6oTu5WS
 IDwgyyuj76NnlVsQzKK5etamGF8/FzOGOaxWTwIeNHc0gxLaaQ
 P48ITAxHWt9a62C5VaEejr3y2m2b9Qfw4UbbihVTqzmtomOwEB
 IrKWh4RU6UKOnrydcXrqd+MIi0VC3Q3CTb4LMRTkQ+QAAIobxo
 C8gprft6QURoq6JLTHqGwFQMX/hRadfJNrxanZkMRjlTeo8h6W
 FbARxM1AK0g+FzTOdpwBn/wm2FsoFvnf0UwEQaweU5MXLr/9G+
 Jd5NRAdStEGZV+xpmydLO7Puh0uxsJNfGQJm9ea5zJvyce3X+s
 OlNIY1oIG7pJ3W578ql8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 June 2013 18:36:05 Maxime Ripard wrote:
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun5i-a10s.dtsi | 286 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 286 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun5i-a10s.dtsi

Would it make sense to split out the parts that are common with A13 into
a separate sun5i.dtsi file?

	Arnd
