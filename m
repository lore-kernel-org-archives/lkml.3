Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936906Ab3DIISI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:18:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11721 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934851Ab3DIISC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:18:02 -0400
Message-ID: <5163CEB7.5030806@atmel.com>
Date: Tue, 9 Apr 2013 10:17:59 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <dgilbert@interlog.com>
Subject: Re: [GIT PULL] at91: DT changes for 3.10 #3
References: <20130402184947.GA8015@quad.lixom.net> <1365094799-16940-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1365094799-16940-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 06:59 PM, Nicolas Ferre :
> Arnd, Olof,
> 
> Here is the refreshed pull-request for AT91 that is dedicated to Device Tree
> modifications. It is stacked on the material that you already have
> for 3.10 in your arm-soc/at91/dt branch.
> Following our discussion with Arnd, I added the non-urgent patches that I
> already proposed too late for 3.9. I also included the moving of macb node
> and kept the original patch.
> 
> As Olof asked, I renamed the Aria board dts file: at91-ariag25.dts and placed
> it in the Makefile. I also took the advantage of this delay to stack two more
> DT related patches.

Ping?

I saw that you made an update to arm-soc yesterday, and maybe you have
forgotten this pull-request?

Thanks, bye,


> Thanks, best regards,
> 
> The following changes since commit 6901d947be5ba1245a0f63271355b95f9056a362:
> 
>   ARM: at91/at91sam9x5cm: add 1-wire chip on CM board (2013-03-21 16:07:15 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
> 
> for you to fetch changes up to f10491fff07dcced77f8ab1b3bc1f8e18715bfb9:
> 
>   ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding (2013-04-04 18:31:17 +0200)
> 
> ----------------------------------------------------------------
> One macb DT node move for 9x5 family: 9g15 doesn't
> have an Ethernet interface.
> Little fixes mainly related to at91sam9x5 DT, IIO ADC bindings,
> pinctrl for at91sam9260/g20 DT and the RTC addition.
> Addition of the Acme Systems Aria G25 board.
> 
> ----------------------------------------------------------------
> Douglas Gilbert (2):
>       ARM: at91: add Acme Systems Aria G25 board
>       ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding
> 
> Ludovic Desroches (1):
>       ARM: at91: dts: add adc resolution stuff
> 
> Nicolas Ferre (5):
>       ARM: at91/at91sam9x5: add RTC node
>       ARM: at91/trivial: typos in compatible property
>       ARM: at91/trivial: fix model name for SAM9G15-EK
>       ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi
>       ARM: at91/dt: fix macb node declaration
> 
>  arch/arm/boot/dts/Makefile          |   1 +
>  arch/arm/boot/dts/at91-ariag25.dts  | 171 +++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9260.dtsi  |  19 ++--
>  arch/arm/boot/dts/at91sam9g15.dtsi  |   2 +-
>  arch/arm/boot/dts/at91sam9g15ek.dts |   2 +-
>  arch/arm/boot/dts/at91sam9g25.dtsi  |   2 +-
>  arch/arm/boot/dts/at91sam9g25ek.dts |   9 ++
>  arch/arm/boot/dts/at91sam9g35.dtsi  |   2 +-
>  arch/arm/boot/dts/at91sam9g35ek.dts |   9 ++
>  arch/arm/boot/dts/at91sam9g45.dtsi  |   3 +
>  arch/arm/boot/dts/at91sam9x25.dtsi  |   2 +-
>  arch/arm/boot/dts/at91sam9x25ek.dts |  14 +++
>  arch/arm/boot/dts/at91sam9x35.dtsi  |   2 +-
>  arch/arm/boot/dts/at91sam9x35ek.dts |   9 ++
>  arch/arm/boot/dts/at91sam9x5.dtsi   |  10 ++
>  arch/arm/boot/dts/at91sam9x5ek.dtsi |   7 +-
>  16 files changed, 244 insertions(+), 20 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91-ariag25.dts
> 


-- 
Nicolas Ferre
