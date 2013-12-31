Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3LaRsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 12:48:39 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:51523 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3LaRsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 12:48:38 -0500
Message-ID: <52C3036D.50503@overkiz.com>
Date: Tue, 31 Dec 2013 18:48:29 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: jjhiblot@traphandler.com, nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/6] Device Tree support for the at91sam9261ek
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 247416505748191321
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean-Jacques

On 31/12/2013 17:32, jjhiblot@traphandler.com wrote:
> From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>
> Hi Nicolas,
>
> This patch set aims at bringing a basic device tree support for the sam9261.
> It's mostly based on the sam9263 stuff.
> The only new thing here is the smc bus driver. It's a very simple bus driver
> used to configure the EBI from the DT. I haven't documented its DT bindings yet
>
> supported features:
> * dbgu
> * nand
> * lcd
> * ethernet
> * leds
>

Cool, one step forward to the removal of at91 board files ;).

I'll try to review this series before the end of the week.

Best Regards,

Boris


> Jean-Jacques
>
> jean-jacques hiblot (6):
>    Basic Device Tree support for the at91sam9261
>    at91: dt: sam9261: Added support for the lcd display
>    At91: dt: Added smc bus driver
>    at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
>    at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
>    at91: dt: sam9261: Added DM9000 in the device tree
>
> jean-jacques hiblot (6):
>    Basic Device Tree support for the at91sam9261
>    at91: dt: sam9261: Added support for the lcd display
>    At91: dt: Added smc bus driver
>    at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
>    at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
>    at91: dt: sam9261: Added DM9000 in the device tree
>
>   arch/arm/boot/dts/at91sam9261.dtsi       | 575 +++++++++++++++++++++++++++++++
>   arch/arm/boot/dts/at91sam9261ek.dts      | 159 +++++++++
>   arch/arm/mach-at91/at91sam9261.c         |  16 +
>   arch/arm/mach-at91/at91sam9261_devices.c |  18 +
>   drivers/bus/Kconfig                      |   9 +
>   drivers/bus/Makefile                     |   1 +
>   drivers/bus/atmel-smc.c                  | 182 ++++++++++
>   7 files changed, 960 insertions(+)
>   create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>   create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
>   create mode 100644 drivers/bus/atmel-smc.c
>

