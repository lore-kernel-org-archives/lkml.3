Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaKTLTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:19:05 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50503 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaKTLTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:19:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee@kernel.org>, linux-kernel@vger.kernel.org, arm@kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Matthias Klein <matthias.klein@linux.com>
Subject: Re: [PATCH] ARM: bcm2835: Add device tree for Raspberry Pi model B+
Date: Thu, 20 Nov 2014 12:18:28 +0100
Message-ID: <2041471.8rvf0EmQUU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416480765-13449-1-git-send-email-lee@kernel.org>
References: <1416480765-13449-1-git-send-email-lee@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ep0M7Ui+Z4T3K8IXWBjDB+uvGVpT31+yuvStFyFGXit
 1oRbqhl01CT8RufGv7UP/GbHc7ioGbTiiYu9Kz7eb3pk4udE+R
 fUb4bN6TUeIHOy1zSvgwqzUtqicKxCsLQmyMLnRyrEd12yjeRg
 qrqaHqc3uMmvkG2kBfL9+BEgXqnV/XEzoBsQVCSx9JiSSpnuEk
 lBaCPF8NWfCv2KwOG+THNj3XOEBnzL7Bw+5MPZa2Kmenh7DfdJ
 T9b/ztIKxdhSpTVb8PDLHF7z10xnCdei8SUR5waU1WgJoSfSeR
 4/ptzdhXG+hoyOSKRfMc+Gv+SXRkrGYY+pN9Ostm8wkmQ2hywT
 0KIaCjn/qxB0D1oUcQsU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2014 10:52:45 Lee Jones wrote:
> From: Matthias Klein <matthias.klein@linux.com>
> 
> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
> I2S interface.
> 
> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
> 
> As requested by Arnd.
> 
>  arch/arm/boot/dts/Makefile               |  1 +
>  arch/arm/boot/dts/bcm2835-rpi-b-plus.dts | 30 +++++++++++++++++++
>  arch/arm/boot/dts/bcm2835-rpi-b.dts      | 46 ++--------------------------
>  arch/arm/boot/dts/bcm2835-rpi.dtsi       | 51 ++++++++++++++++++++++++++++++++
>  4 files changed, 85 insertions(+), 43 deletions(-)
>  create mode 100644 arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
>  create mode 100644 arch/arm/boot/dts/bcm2835-rpi.dtsi
> 

Applied to next/dt.

When you send a patch for inclusion the next time, better
be explicit and ask for it to be picked up into arm-soc, so we
know it's not just for review.

Thanks,

	Arnd
