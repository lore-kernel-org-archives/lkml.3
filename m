Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaLOEJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 23:09:35 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:45199 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLOEJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 23:09:30 -0500
MIME-Version: 1.0
In-Reply-To: <557b9b23d0313dede22786d9550c7867d9f22837.1418434448.git.silvio.fricke@gmail.com>
References: <cover.1418434448.git.silvio.fricke@gmail.com>
	<557b9b23d0313dede22786d9550c7867d9f22837.1418434448.git.silvio.fricke@gmail.com>
Date: Mon, 15 Dec 2014 09:39:29 +0530
X-Google-Sender-Auth: x_dEy9DzBaPOcrvb8ycb_IioNjA
Message-ID: <CAOh2x=nhH--HPxzN+rq_LZTwBQYTXFb9N562X_rbZkLsr+N7zA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: SPEAr: dts: remove unused irq-trigger, id and
 block entries
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2014 at 7:16 AM, Silvio Fricke <silvio.fricke@gmail.com> wrote:
> Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Jason Cooper <jason@lakedaemon.net>
> CC: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/boot/dts/spear1310-evb.dts | 1 -
>  arch/arm/boot/dts/spear1340-evb.dts | 2 --
>  arch/arm/boot/dts/spear320-hmi.dts  | 3 ---
>  3 files changed, 6 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
