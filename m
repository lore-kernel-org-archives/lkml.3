Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966312AbaLMJVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 04:21:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:49206 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966260AbaLMJVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 04:21:35 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Silvio Fricke <silvio.fricke@gmail.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH 0/3] removing of some unused/unsupported dts entries
In-Reply-To: <cover.1418434448.git.silvio.fricke@gmail.com> (Silvio Fricke's
	message of "Sat, 13 Dec 2014 01:46:45 +0000")
Organization: ARM Ltd
References: <cover.1418434448.git.silvio.fricke@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
Date: Sat, 13 Dec 2014 09:21:23 +0000
Message-ID: <8761dfgb1o.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13 2014 at  1:46:45 am GMT, Silvio Fricke <silvio.fricke@gmail.com> wrote:

Hi Silvio,

> I have found some dts entries which are not evaluated by the drivers. This
> patch remove this entries from the dts files.
> Jason has mentioned I should CC: Thomas, Marc and him self to this
> mails.

As far as I can tell, this looks correct. A few key things though:

- Please write decent commit logs. Indicate *why* you think these
  properties can be removed (hint: not finding corresponding in the
  drivers is not enough a reason, the binding itself matters).

- Spend two minutes looking at the ML archives, and try to find why we
  ended-up with these orphan properties (something like this:
  https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-November/023482.html
  contains useful historical information).

- Cc the relevant platform maintainers. You're changing things that they
  care about, basic courtesy is to keep them in the loop.

All of this will help maintainers to quickly decide on the fate of these
patches.

Thanks,

	M.

> thanks and best regards,
> Silvio
>
>
> Silvio Fricke (3):
>   ARM: mx5: dts: remove unused irq-trigger entry
>   ARM: tegra: dts: remove unused irq-trigger entry
>   ARM: SPEAr: dts: remove unused irq-trigger, id and block entries
>
>  arch/arm/boot/dts/imx53-m53.dtsi      | 1 -
>  arch/arm/boot/dts/spear1310-evb.dts   | 1 -
>  arch/arm/boot/dts/spear1340-evb.dts   | 2 --
>  arch/arm/boot/dts/spear320-hmi.dts    | 3 ---
>  arch/arm/boot/dts/tegra30-apalis.dtsi | 1 -
>  5 files changed, 8 deletions(-)

-- 
Without deviation from the norm, progress is not possible.
