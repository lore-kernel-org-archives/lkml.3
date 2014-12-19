Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaLSMcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:32:41 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46187 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSMcj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:32:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
References: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
Date: Fri, 19 Dec 2014 13:32:38 +0100
Message-ID: <CAPDyKFoDQyrvZbCUYgvJFr-OVDkhm_EVc3TJ6Fuw1fD4ZQ6ABw@mail.gmail.com>
Subject: Re: [PATCH 0/4] mmc: sunxi: General fixup (v2)
From: Ulf Hansson <ulf.hansson@linaro.org>
To: =?UTF-8?Q?David_Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?B?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2014 at 15:10, David Lanzendörfer
<david.lanzendoerfer@o2s.ch> wrote:
> Hello
> This patchset was inspired questions from 李想 of Allwinner and incorporates as
> well suggestions from Hans related to spin locks.
> For example have not all attributes of the shared host object been protected
> by the spin lock, this has been changed.
> Also some register names and reset behavior have been fixed now.
> And a minor cleanup happened at the clock frequecy setting, since there has
> been a piece of left over code which has been there because it was in the Android
> driver and we just adapted it because we didn't have proper documentation about
> the timing of the module.
>
> Looking forward to your feedback
> Cheers David

Thanks! Queued for 3.20.

Kind regards
Uffe

>
> ---
>
> David Lanzendörfer (3):
>       mmc: sunxi: Lock fix
>       mmc: sunxi: Correcting SDXC_HARDWARE_RESET bit
>       mmc: sunxi: Removing unused code
>
> Hans de Goede (1):
>       mmc: sunxi: Fix setup of last descriptor of dma transfer
>
>
>  drivers/mmc/host/sunxi-mmc.c |   29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> --
> Signature
