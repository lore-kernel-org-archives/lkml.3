Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaHKPqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:46:45 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36328 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaHKPqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk>
Date: Mon, 11 Aug 2014 08:46:42 -0700
X-Google-Sender-Auth: EZY1OMxk4jQAqAS_ZCRcVs0ppX0
Message-ID: <CAD=FV=UbckfwGucuPjEtHixVgF5K2fD5N3EPS2BH96DRDACuqw@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/2] ARM: dts: Improve Peach Pit and Pi power scheme
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Aug 11, 2014 at 4:38 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The DeviceTree files for the Peach Pit and Pi machines have
> a simplistic model of the connections between the different
> regulators since not all the tps65090 regulators get their
> input supply voltage from the VDC. DCDC1-3, LD0-1 and fet7
> parent supply is indded VDC but the fet1-6 get their input
> supply from the DCDC1 and DCDC2 output voltage rails.
>
> Update the DeviceTree to better reflect the real connections
> between tps65090 regulators. Having this information in the
> DTS is useful since FETs are switches that don't provide an
> output voltage so the regulator core needs to fetch the FET
> parent output voltage if the child voltage is queried.
>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Acked-by: Mark Brown <broonie@linaro.org>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 12 ++++++------
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 12 ++++++------
>  2 files changed, 12 insertions(+), 12 deletions(-)

Matches my schematics.  Kukjin: I think this could be applied to
for-next whenever it's convenient.

Acked-by: Doug Anderson <dianders@chromium.org>
